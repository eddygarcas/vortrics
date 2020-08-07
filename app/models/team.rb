require_relative '../../app/helpers/numeric'
class Team < ApplicationRecord
  include JiraActions
  belongs_to :project_info

  has_many :sprints, -> {order(enddate: :desc)}, dependent: :destroy
  has_many :team_advices, dependent: :destroy
  has_many :advices, through: :team_advices
  has_one :retrospective, dependent: :destroy

  attr_writer :issues, :sprint, :changelog

  scope :by_setting, -> (setting_id) {where(:setting_id => setting_id)}
  scope :scrum, -> {where(board_type: [nil, 'scrum'])}
  scope :kanban, -> {where(board_type: 'kanban')}
  scope :progress_by_project, -> (key) {where("project = ?", key).all.sort_by {|e| e.sprint.enddate}}

  def sprint
     sprints.active
  end

  def issues
    sprint&.issues
  end

  def scrum?
    board_type.eql?('scrum') || board_type.blank?
  end

  def no_sprint?
    scrum? && sprints.empty?
  end

  def kanban?
    board_type.eql?('kanban')
  end

  def no_kanban?
    kanban? && issues.blank?
  end

  def overcommitment?
    sprint.sprint_commitment > average_closed_points
  end

  def more_than_one_sprint?
    sprint.issues.any?(&:more_than_sprint?)
  end

  def has_service_types?
    issues.any?(&:task?) && issues.any?(&:bug?)
  end

  def issues_selectable_for_graph
    Rails.cache.fetch("issues_selectable_for_graph_#{id}", expires_in: 1.day) {
      Issue.joins(:sprint).where('team_id = ?', id).select('issues.*').select(&:selectable_for_cycle_time?).sort_by!(&:cycle_time)
    }
  end

  def average_time
    average = Rails.cache.fetch("average_time_#{id}", expires_in: 1.day) {
      issues_selectable_for_graph.map {|issue| issue.cycle_time.abs}.average
    }
    average.nan? ? 0 : average.round(2)
  end

  def wip_limit
    begin
    Montecasting::Metrics.wip_limit(
        issues_selectable_for_graph.map(&:cycle_time),
        sprints.last.start_date)&.round(0)
    rescue FloatDomainError
      return 0
    end
  end

  def throughput
    Montecasting::Metrics.throughput(
        issues_selectable_for_graph.count,
        sprints.last.start_date).round(2)
  end

  def days
    sorted_sprints = sprints.sort_by(&:enddate)
    (sorted_sprints.first.start_date..sorted_sprints.last.enddate).select { |day| !day.sunday? && !day.saturday? }.count
  end

  def average_closed_points
    sum_by_column(:closed_points).round.to_i
  end

  def average_stories
    sum_by_column(:stories).round.to_i
  end

  def average_bugs
    sum_by_column(:bugs).round.to_i
  end

  def rate_process
    (100 - sprints.map(&:ratio_items_flagged).average.to_i) / 20
  end

  def rate_quality
    sprints.map(&:first_time_pass).average.to_i / 20
  end

  def rate_delivery
    percent_of_time(Vortrics.config[:baseline][:leadtime],:lead_time).to_i / 20
  end

  def percent_of_time days = Vortrics.config[:baseline][:cycletime],field = :cycle_time
    Montecasting::Metrics.percent_of_items_at(issues_selectable_for_graph.map(&field),days)
  end

  def percent_of_capacity
    current_capacity.percent_of(max_capacity).round(0)
  end

  def points_variance
    Montecasting::Metrics.variance(sprints.recent.map(&:closed_points)).round(0)
  end

  def stories_variance
    Montecasting::Metrics.variance(sprints.recent.map(&:stories)).round(0)
  end

  def bar_percent_of tag = :new?
    begin
      sprint&.issues&.select(&tag).count.percent_of(sprint&.issues&.count).round(0)
    rescue StandardError
      0
    end
  end

  def array_of_data_for_graph column_name
    sprints.select(column_name).order(:enddate).map.with_index {|x, index| [index, x[column_name]]}.presence || []
  end

  def axis_graph_by_column column_name, sum_column_name = nil
    data = []
    select = "id as x,#{column_name} as y"
    select << ",#{sum_column_name} as z" unless sum_column_name.blank?
    sprints.select(select).where('enddate <= ?', Date.today)
        .order(:enddate).each_with_index {|points, index|
      p = points.y
      p += points.z unless sum_column_name.blank?
      data << {x: index, y: p}
    }
    data.to_json(except: :id)
  end

  def all_sprint_names
    sprints.names_safe
  end

  def longer_issue
    issues_selectable_for_graph.last.presence || issues.first
  end

  def shortest_issue
    issues_selectable_for_graph.first.presence || issues.first
  end

  def update_active_sprint p = {}
    Sprint.find_or_initialize_by(sprint_id: p.sprint_id).update(p.to_h.compact)
  end

  protected

  def sum_by_column column_name
    sprints.select(column_name).average(column_name).presence || 0
  end
end
