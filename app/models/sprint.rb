class Sprint < ApplicationRecord
  belongs_to :team
  has_many :issues, dependent: :destroy

  attr_accessor :scope

  scope :active, ->{order(enddate: :desc).first}
  scope :recent, -> {where('enddate <= ?', Date.today).take(5)}
  scope :names_safe, -> {select(:name).order(:enddate).to_json(except: :id).html_safe}


  def save_issues issues = []
    Issue.transaction do
      issues.each {|i| i.sprint_id = id}
      issues.each(&:save!)
      issues.each(&:save_changelog)
    end
  end

  def next
    begin
      team.sprints.where("id > ?", id).first!
    rescue ActiveRecord::RecordNotFound => e
      return self
    end
  end

  def prev
    begin
      team.sprints.where("id < ?", id).last!
    rescue ActiveRecord::RecordNotFound => e
      return self
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

  def items_flagged_by_sprint
    items_flagged.count
  end

  def time_in_flagged
    time_in_log.round
  end

  def ratio_time_flagged
    begin
      ((time_in_log.days / 1.hour) / issues.select(&:task?).count.to_f).round(0)
    rescue FloatDomainError => e
      return 0
    end
  end

  def ratio_items_flagged
    begin
      items_flagged.count.percent_of(issues.select(&:task?).count).round(0)
    rescue FloatDomainError => e
      return 0
    end
  end

  def first_time_pass
    first_time = 0
    issues.select(&:task?).each {|item|
      first_time += 1 if item.first_time_pass_rate?
    }
    first_time
  end

  def total_stories
    self.remainingstories = 0 if self.remainingstories.blank?
    stories + remainingstories
  end


  def changed_scope added
    @scope = added.to_f.percent_of(total_stories.to_f).round
  end

  def sprint_commitment
    return 0 if issues.blank?
    issues.map {|elem| elem.customfield_11802.to_i}.inject(0) {|sum, x| sum + x}
  end

  def sprint_cycle_time
	  issues.map(&:cycle_time).average.ceil.to_i
  end

  def sprint_lead_time
	  issues.map(&:lead_time).average.ceil.to_i
  end

  def wip_limit
    (sprint_cycle_time * throughput).round(0)
  end

  def days
    (start_date..enddate).count
  end

  def throughput
    ((stories + bugs).to_f / days).round(2)
  end

  def week_days
    (start_date..enddate + 1).select { |day| !day.sunday? && !day.saturday? }
  end


  protected


  def time_in_log
    timein = 0
    items_flagged.each {|elem| timein += elem.time_flagged.to_i}
    timein
  end

  def items_flagged
    issues.each(&:change_logs).select(&:flagged?)
  end

end
