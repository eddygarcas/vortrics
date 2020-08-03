class ChangeLog < ApplicationRecord
  include Binky::Helper
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

end