class Sprint < ApplicationRecord
  belongs_to :team
  has_many :issues, dependent: :destroy

  attr_accessor :scope

  scope :active, ->{order(enddate: :desc).first}
  scope :recent, -> {where('enddate <= ?', Date.today).take(5)}
  scope :names_safe, -> {select(:name).order(:enddate).to_json(except: :id).html_safe}

  def save_issues jiraissue = []
    Issue.transaction do
      jiraissue.each do |i|
        issue = Issue.find_or_initialize_by(key: i.key,sprint_id: id)
        issue.update(i.to_hash)
        issue.save_changelog
      end
    end
  end

  def active_sprints project
    Rails.cache.fetch("active_sprints_#{project}", expires_in: 1.hour) {
      Sprint.joins(:team).select('sprints.*,teams.name as team_name').where('project = ? and enddate >= ? ', project, Date.today.prev_weekday)
    }
  end

  def issues?
    issues.exists?
  end

  def trend_stories
    begin
      return 0 if self.blank? || (stories.eql? 0)
      stories.percent_of(team.average_stories).round - 100
    rescue Errors
      0
    end
  end

  def trend_bugs
    begin
      return 0 if self.blank? || (bugs.eql? 0)
      bugs.percent_of(team.average_bugs).round - 100
    rescue StandardError
      0
    end
  end

  def trend_points
    return 0 if self.blank? || (closed_points.eql? 0)
    (closed_points - team.average_closed_points).round
  end


  def items_flagged_by_sprint
    items_flagged.count
  end

  def time_in_flagged
    time_in_log.round
  end

  def ratio_time_flagged
    begin
      ((time_in_log.days / 1.hour) / issues.select(&:task?).count.to_f).round(0)
    rescue FloatDomainError
      0
    end
  end

  def ratio_items_flagged
    begin
      items_flagged.count.percent_of(issues.select(&:task?).count).round(0)
    rescue FloatDomainError
      0
    end
  end

  def first_time_pass
    issues&.select(&:task?).map {|item| item.first_time_pass_rate?.to_i}.inject(&:+).percent_of(total_stories).round
  end

  def total_stories
    stories + (remainingstories.presence || 0)
  end

  def sprint_commitment
    issues&.map {|elem| elem.customfield_11802.to_i}.inject(0) {|sum, x| sum + x}.presence || 0
  end

  def sprint_cycle_time
	  issues.map(&:cycle_time).average.ceil.to_i
  end

  def sprint_lead_time
	  issues.map(&:lead_time).average.ceil.to_i
  end

  def days
    (start_date..enddate).count
  end

  def week_days
    (start_date..enddate + 1).select { |day| !day.sunday? && !day.saturday? }
  end

  protected

  def time_in_log
    items_flagged&.map(&:time_flagged).inject(&:+).to_i
  end

  def items_flagged
    Rails.cache.fetch("items_flagged_#{sprint_id}", expires_in: 1.day) {
      issues&.each(&:change_logs).select(&:flagged?)
    }
  end

end
