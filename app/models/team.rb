#require 'open-uri'
require_relative '../../app/helpers/jira_helper'
require_relative '../../app/helpers/array'
require_relative '../../app/helpers/numeric'

class Team < ApplicationRecord
  include JiraHelper
  belongs_to :project_info

  has_many :sprints, -> {order(enddate: :desc)}, dependent: :destroy
  has_many :assesments, dependent: :destroy
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
    return nil unless sprint.present?
    sprint.issues
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
      #limit = Vortrics.config[:performance][:graph_limit].to_i
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
    sum_by_colum(:closed_points).round.to_i
  end

  def average_stories
    sum_by_colum(:stories).round.to_i
  end

  def average_bugs
    sum_by_colum(:bugs).round.to_i
  end

  def percent_of_lead_time days = Vortrics.config[:baseline][:leadtime]
    Montecasting::Metrics.percent_of_items_at(issues_selectable_for_graph.map(&:cycle_time),days)
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

  def trend_stories
    begin
      return 0 if sprint.blank? || (sprint.stories.eql? 0)
      sprint.stories.percent_of(average_stories).round - 100
    rescue Errors
      0
    end
  end

  def trend_bugs
    begin
      return 0 if sprint.blank? || (sprint.bugs.eql? 0)
      sprint.bugs.percent_of(average_bugs).round - 100
    rescue StandardError
      0
    end
  end

  def trend_points
    return 0 if sprint.blank? || (sprint.closed_points.eql? 0)
    (sprint.closed_points - average_closed_points).round
  end

  def bar_percent_of tag = :new?
    return 0 if sprint.blank? || sprint.issues.blank?
    begin
      sprint.issues.select(&tag).count.percent_of(sprint.issues.count).round(0)
    rescue StandardError => e
      0
    end
  end


  def array_of_data_for_graph column_name
    stories_data = []
    sprints.select(column_name).order(:enddate).each_with_index {|x, index| stories_data << [index, x[column_name]]}
    stories_data
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
    issue = issues_selectable_for_graph.last
    return issues.first if issue.blank?
    issue
  end

  def shortest_issue
    issue = issues_selectable_for_graph.first
    return issues.first if issue.blank?
    issue
  end

  def update_sprint sprint, issues
    data = sprint_data issues, sprint.sprint_id.to_s
    sprint.closed_points = data[:closed_points]
    sprint.stories = data[:stories]
    sprint.bugs = data[:bugs]
    sprint.remainingstories = data[:openstories]
    sprint.remaining_points = data[:remaining_points]
    if sprint.save!
      yield
    end
  end

  def store_sprint issues, params = nil
    store_scrum_sprint issues do
      params.blank? ? {id: nil, name: "#{name} Kanban", endDate: Time.zone.now.to_date, startDate: issues.last.created} :
          {id: params[:id], name: params['name'], endDate: params['endDate'], startDate: params['startDate']}
    end
    yield

  end

  protected

  def store_scrum_sprint issues

    sprint_params = yield
    enddate = sprint_params[:endDate].blank? ? Time.new.to_date : sprint_params[:endDate].to_date
    startdate = sprint_params[:startDate].blank? ? Time.new.to_date : sprint_params[:startDate].to_date

    data = sprint_data issues, sprint_params[:id]

    update_active_sprint sprint: {
        name: sprint_params[:name],
        stories: data[:stories],
        remainingstories: data[:openstories],
        bugs: data[:bugs],
        closed_points: data[:closed_points],
        remaining_points: data[:remaining_points],
        enddate: enddate,
        start_date: startdate,
        team_id: id,
        sprint_id: sprint_params[:id].blank? ? board_id : sprint_params[:id]
    }
  end

  def sprint_data issues, sprintid = nil
    #At this point issue has all closed in this sprint and the future ones.
    sprintData = {}

    current_issues = sprintid.present? ? issues.select {|el| el.closed_in.include? sprintid unless el.closed_in.blank?} : issues
    exclude_issue =  sprintid.present? ? issues.select {|el| el.closed_in.exclude? sprintid unless el.closed_in.blank?} : []


    sprintData[:closed_points] = current_issues.each_sum_done {|elem| elem.customfield_11802.to_i}
    sprintData[:stories] = current_issues.each_sum_done {|elem| elem.task? ? 1 : 0}
    sprintData[:bugs] = current_issues.each_sum_done {|elem| elem.bug? ? 1 : 0}

    sprintData[:openstories] = current_issues.each_sum_done([:new, :indeterminate]) {|elem| elem.task? ? 1 : 0}
    sprintData[:remaining_points] = current_issues.each_sum_done([:new, :indeterminate]) {|elem| elem.customfield_11802.to_i}

    sprintData[:openstories] += exclude_issue.select(&:task?).count
    sprintData[:remaining_points] += exclude_issue.each_sum {|elem| elem.customfield_11802.to_i}
    sprintData
  end

  #Sprit by a given team id
  def sum_by_colum column_name
    sum_colum = sprints.select(column_name).average(column_name)
    sum_colum.blank? ? 0 : sum_colum
  end

  def update_active_sprint p = {}
    Sprint.find_or_initialize_by(name: p[:sprint][:name]).update(p[:sprint])
  end
end
