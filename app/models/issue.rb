require_relative '../../app/helpers/time'
class Issue < ApplicationRecord
	include DataBuilderHelper

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
		(time_transitions({ toString: :first }, { toString: :done })).abs
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
		(issuetypeid.eql? 10104 || issuetype.downcase.eql?('subtask'))
	end

	def bug?
		(issuetypeid.eql?(4) || issuetype.downcase.eql?('bug'))
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
		return false if done_date.blank?
		date.yday.eql? done_date.created.to_datetime.yday
	end

	def wip_date
		changelog_lapse(:toString, :wip, &:first)
	end

	def done_date
		changelog_lapse(:toString, :done, &:last)
	end

	def first_time_pass_rate?
		change_logs.select(&:first_time_review?).count.eql? 1
	end

	def time_in initial, final, format = true
		return 0 if change_logs.blank? && initial.eql?(:first)
		return life_time if change_logs.blank?
		times_in = []
		times_in << changelog_lapse(:toString, initial, &:first)
		times_in << changelog_lapse(:toString, final, &:first)
		times_in << changelog_lapse(:toString, :first, &:first) if (times_in.compact!.present?)
		return times_in.inject { |sum, number| sum.created - number.created } unless format
		times_in.inject { |sum, number| sum.remaining(number) }
	end

	def life_time
		return nil if created.blank?
		return updated - created if resolutiondate.blank?
		resolutiondate - created
	end



	def save_changelog
		return if histories.blank?
		ChangeLog.transaction do
			histories.each { |elem|
				log = ChangeLog.new
				log.parse_and_initialize elem, id
				ChangeLog.find_or_initialize_by(id: log.id).update(log.to_hash)
			}
		end
	end

	protected

	def save_cycle_time
		write_attribute(:cycle_time, (time_transitions({ toString: :wip }, { toString: :done })).abs)
		save!
	end

	def time_transitions start = {}, finish = {}
		return 0 if change_logs.blank?
		time_stamps = []
		start.each_pair { |method, tag| time_stamps << changelog_lapse(method, tag, &:first) }
		finish.each_pair { |method, tag| time_stamps << changelog_lapse(method, tag, &:first) }
		#Next call will avoid the chance of no testing state, so will get the WIP time towards the last recor
		finish.each_pair { |method,tag| time_stamps[1] = changelog_lapse(method, :done, &:last) } if time_stamps[1].blank?

		return 0 if time_stamps[0].blank? || time_stamps[1].blank?
		time_stamps.sort_by!(&:created)
		time_stamps[0].created.to_date.business_days_until(time_stamps[1].created.to_date).to_f
	end

	def changelog_lapse column, tag
		return nil if change_logs.blank?
		return change_logs.first if tag.eql? :first
		return change_logs.last if tag.eql? :last
		yield change_logs.select { |log| workflow_stats(tag, log.send(column)) unless log.send(column).blank? }
	end

	private

	def workflow_stats tag, column
		return Vortrics.config[:changelog][tag].include? column.to_s.downcase unless User.workflow(tag).present?
		User.workflow(tag).include? column.to_s.downcase
	end

end
