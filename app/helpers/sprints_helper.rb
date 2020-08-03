require_relative 'array'
module SprintsHelper

  class SprintBuilder
    include Binky::Struct
    alias :super_initialize :initialize

    def initialize(issues = [], params = nil)
      super_initialize params
      generate_sprint_info(issues) unless issues.blank?
    end


    def generate_sprint_info(issues = nil)
      current_issues = scrum? ? issues.select {|el| el.closed_in.include? id} : issues
      exclude_issue = scrum? ? issues.select {|el| el.closed_in.exclude? id} : []

      self.closed_points = current_issues.each_sum_done {|elem| elem.story_points.to_i}

      self.stories = current_issues.each_sum_done {|elem| elem.task? ? 1 : 0}
      self.bugs = current_issues.each_sum_done {|elem| elem.bug? ? 1 : 0}

      self.openstories = current_issues.each_sum_done([:new, :indeterminate]) {|elem| elem.task? ? 1 : 0}
      self.remaining_points = current_issues.each_sum_done([:new, :indeterminate]) {|elem| elem.story_points.to_i}

      self.openstories += exclude_issue.select(&:task?).count
      self.remaining_points += exclude_issue.each_sum {|elem| elem.story_points.to_i}
    end

    def to_sprint
      {
          name: self.name,
          stories: self.stories,
          remainingstories: self.openstories,
          bugs: self.bugs,
          closed_points: self.closed_points,
          remaining_points: self.remaining_points,
          enddate: self.endDate,
          start_date: self.startDate,
          team_id: self.team_id,
          sprint_id: self.id
      }.compact
    end

    def kanban?
      self.board_type.eql? "kanban"
    end

    def scrum?
      self.board_type.eql? "scrum"
    end
  end

  def sort_link(column, title = nil, param = {})
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    link_to "<span class='fa fa-fw fa-sort'> </span> #{title} <span class='#{icon}'></span>".html_safe, param.merge({column: column, direction: direction})
  end

  def formatDate dateAsString
    return 'n/d' if dateAsString.blank?
    Date.parse(dateAsString).strftime('%A, %d/%b/%Y')
  end

  def tag_info_table value, color = :black, type = :default
    typehash = {default: '', percent: '%', hours: 'h', days: 'Days', bugs: 'Bugs', items: 'Items'}
    content_tag(:span, content_tag(:strong, "#{value} ") << typehash[type], class: "strong", style: "color: #{color}")
  end

end
