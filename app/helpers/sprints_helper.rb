require_relative 'array'
require_relative 'logic'

module SprintsHelper

  class SprintBuilder
    include Binky::Struct
    alias :super_initialize :initialize

    def initialize(issues = [], params = nil)
      super_initialize params
      generate_sprint_info(issues) unless issues.blank?
    end

    def generate_sprint_info(issues = nil)
      current_issues = scrum? ? issues.select {|el| el.closed_in.include? sprint_id} : issues
      exclude_issue = scrum? ? issues.select {|el| el.closed_in.exclude? sprint_id} : []

      self.closed_points = current_issues&.map_sum_done(&:story_points).compact.inject(&:+).to_i
      self.stories = current_issues&.map_sum_done(&:task?).map(&:to_i).inject(&:+).to_i
      self.bugs = current_issues&.map_sum_done(&:bug?).map(&:to_i).inject(&:+).to_i
      self.remainingstories = current_issues&.map_sum_done([:new, :indeterminate],&:task?).map(&:to_i).inject(&:+).to_i
      self.remaining_points = current_issues&.map_sum_done([:new, :indeterminate],&:story_points).compact.inject(&:+).to_i
      self.remainingstories += exclude_issue.select(&:task?).count
      self.remaining_points += exclude_issue.map_sum(&:story_points).compact.inject(&:+).to_i
      self.change_scope = self.change_scope.to_f.percent_of(self.stories + self.remainingstories).to_i
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
