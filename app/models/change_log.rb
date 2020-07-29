class ChangeLog < ApplicationRecord
  include DataBuilderHelper
  include ActiveModel::AttributeMethods
  belongs_to :issue

  def parse_and_initialize jira_log, issue_id, index = 1
    parse jira_log, index do |log|
      break if log['items'].blank?
      send("issue_id=", issue_id)
      send_attribute('avatar', jira_log, '48x48')
      ChangeLog.column_names.each { |key|
        send_attribute(key, log)
      }
    end
  end

  def flagged?
    return Vortrics.config[:changelog][:flagged].include? toString.to_s.downcase unless User.workflow(:flagged).present?
    User.workflow(:flagged).include? toString.to_s.downcase
  end

  def first_time_review?
    return Vortrics.config[:changelog][:testing].include? toString.to_s.downcase unless User.workflow(:testing).present?
    User.workflow(:testing).include? toString.to_s.downcase
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

  def parse log, index = 1
    log['items'].keep_element_if 'field', Vortrics.config[:jira][:changelogfields] unless index.eql?0
    log['items'].keep_if { |e| e.dig('fromString').present? } unless index.eql?0
    yield log
  end

  def send_attribute instance_variable, hash_element, inner_key = nil
    v = nested_hash_value(hash_element, inner_key.present? ? inner_key : instance_variable.to_s)
    send("#{instance_variable}=", v) unless v.blank?
  end
end