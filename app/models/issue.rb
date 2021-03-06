require_relative '../../app/helpers/time'

class Issue < ApplicationRecord

  belongs_to :sprint
  has_many :change_logs, dependent: :destroy

  has_many :actions
  has_many :advices, through: :actions

  attr_accessor :closed_in, :histories, :active
  alias :active? :active

  def self.seach_for column, criteria
    issues = Issue.where("lower(#{column}) LIKE ?", "%#{criteria.to_s.downcase}%").all
    return issues, (issues.count.eql? 1)
  end

  def cycle_time
    return 0.0 unless selectable_for_cycle_time?
    save_cycle_time if read_attribute(:cycle_time).blank?
    read_attribute(:cycle_time)
  end

  def lead_time
    (time_transitions({ toString: :first }, { toString: :done }))
  end

  def new?
    status.eql? 'new'
  end

  def done?
    ((status.eql? 'done') && (resolutiondate.present?))
  end

  def in_progress?
    status.eql? 'indeterminate'
  end

  def more_than_sprint? num = 2
    customfield_11382.to_i > num
  end

  def subtask?
    issuetype.downcase.eql?('subtask')
  end

  def bug?
    issuetype.downcase.eql?('bug')
  end

  def epic?
    issuetype.downcase.eql?('epic')
  end

  def task?
    !subtask? && !bug? && !epic?
  end

  def selectable_for_graph?
    done? && task? && any_log?
  end

  def selectable_for_cycle_time?
    done? && !subtask? && any_log?
  end

  def selectable_for_kanban?
    !epic? && !subtask?
  end

  def save_logs?
    done? && change_logs.blank?
  end

  def any_log?
    change_logs.any?
  end

  def flagged?
    change_logs.any?(&:flagged?)
  end

  def time_flagged
    (time_transitions({ fromString: :flagged }, { toString: :flagged })).abs
  end

  def time_in_wip
    (time_transitions({ toString: :wip }, { toString: :testing })).abs
  end

  def time_to_release
    (time_transitions({ toString: :testing }, { toString: :done })).abs
  end

  def time_in_backlog
    (time_transitions({ toString: :first }, { toString: :wip })).abs
  end

  def was_wip? date
    return false if wip_date.blank?
    return (wip_date.created.to_date..Time.zone.now).cover? date if done_date.blank?
    (wip_date.created.to_date..done_date.created.to_date).cover? date
  end

  def was_done? date
    date.yday.eql? done_date&.created&.to_datetime.yday
  end

  def wip_date
    changelog_lapse(:toString, :wip, &:first)
  end

  def done_date
    changelog_lapse(:toString, :done, &:last)
  end

  def first_time_pass_rate?
    change_logs.select(&:first_time_review?).count <= 1
  end

  def time_transitions(start = {}, finish = {})
    time_in start, finish, false, :done, :last
  end

  def time_in(start = {}, finish = {}, format = true, alternative_tag = :done, alternative_pos = :last)
    return 0 if change_logs.blank? && start.keys.first.eql?(:first)
    return life_time format if change_logs.blank?
    times_in = []
    times_in << changelog_lapse(start.keys.first, start.fetch(start.keys.first), &:first) || changelog_lapse(start.keys.first, :first, &:first)
    times_in << changelog_lapse(finish.keys.first, finish.fetch(finish.keys.first), &:first) || changelog_lapse(finish.keys.first, alternative_tag, &alternative_pos)
    return 0 unless times_in.all?
    return times_in.sort_by!(&:created).inject { |sum, number| sum.created.to_date.business_days_until(number.created.to_date) } unless format
    times_in.sort_by!(&:created).inject { |sum, number| sum.remaining(number) }
  end

  def life_time(format = true)
    return 0 if created.blank?
    finish = resolutiondate.blank? ? updated : resolutiondate
    return created.to_date.business_days_until(finish.to_date).to_f unless format
    finish.remaining(finish)
  end

  def save_changelog
    histories.each { |elem| ChangeLog.find_or_initialize_by(id: elem.id).update(elem.as_json.merge({ issue_id: id }).compact) }
  end

  protected

  def save_cycle_time
    write_attribute(:cycle_time, (time_transitions({ toString: :wip }, { toString: :done })).abs)
    save!
  end

  def changelog_lapse(column, tag)
    return change_logs&.first if tag.eql? :first
    return change_logs&.last if tag.eql? :last
    yield change_logs&.select { |log| log.send(column).present? && workflow_stats(tag, log.send(column)) }
  end

  private

  def workflow_stats(column, tag)
    (User.workflow(column).include? tag.to_s.downcase) || (Vortrics.config[:changelog][column].include? tag.to_s.downcase)
  end

end
