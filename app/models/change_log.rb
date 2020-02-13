require_relative '../../app/helpers/data_builder_helper'

#This class will sotore changelog information form JIRA JiraIssue
class ChangeLog < ApplicationRecord
  include DataBuilderHelper
  include ActiveModel::AttributeMethods
  belongs_to :issue

  def flagged?
    return Vortrics.config[:changelog][:flagged].include? toString.to_s.downcase unless User.workflow(:flagged).present?
    User.workflow(:flagged).include? toString.to_s.downcase
  end

  def first_time_review?
    return Vortrics.config[:changelog][:testing].include? toString.to_s.downcase unless User.workflow(:testing).present?
    User.workflow(:testing).include? toString.to_s.downcase
  end


  # Regardless of the jira_log value, this method will match log value within a ChangeLog record.
  def parse_and_initialize jira_log, issue_id
    return if issue_id.blank? || jira_log.blank?
    jira_log['items'].keep_element_if 'field',Vortrics.config[:jira][:changelogfields]
    return if jira_log['items'].blank?
    send("issue_id=", issue_id)
    send_attribute('avatar',jira_log,'48x48')
    ChangeLog.column_names.each { |key|
      send_attribute(key,jira_log)
    }
  end

  def remaining toDate
    return 'n/d' if toDate.blank?
    intervals = [["d", 1], ["h", 24], ["m", 60]]
    elapsed = toDate.created.to_datetime - created.to_datetime
    interval = 1.0
    parts = intervals.collect do |name, new_interval|
      interval /= new_interval
      number, elapsed = elapsed.abs.divmod(interval)
      "#{number.to_i}#{name}" unless number.to_i == 0
    end
    "#{parts.join}"
  end

  def to_hash
    {toString: toString, fromString: fromString, created: created, issue_id: issue_id, avatar: avatar, displayName: displayName, fieldtype: fieldtype}
  end

  private

  def  send_attribute key, log, aka = nil
    v = nested_hash_value(log, aka.present? ? aka : key.to_s)
    send("#{key}=", v) unless v.blank?
  end
end