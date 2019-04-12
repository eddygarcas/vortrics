require_relative '../../app/helpers/data_builder_helper'

class JiraIssue
  include DataBuilderHelper

  attr_accessor :key,:histories,:sprint,:closedSprints

  def initialize elem = nil
    parse_issue elem unless elem.nil?
  end


  def more_than_sprint? num = 2
    customfield_11382.count > num
  end

  def subtask?
    issuetype[:subtask.to_s]
  end

  def bug?
    (issuetype[:id.to_s].eql?('4') || issuetype['name'].downcase.eql?('bug'))
  end

  def task?
    true unless subtask? || bug?
  end

  def new?
    [:new].include? status[:statusCategory.to_s][:key.to_s].to_sym
  end

  def done?
    [:done].include? status[:statusCategory.to_s][:key.to_s].to_sym
  end

  def in_progress?
    [:indeterminate].include? status[:statusCategory.to_s][:key.to_s].to_sym
  end

  #This operation will require to analize both closed and sprint due to once the sprint is finish both are comming as part of the get issues message
  def to_issue
    issue = Issue.find_by_key(key)
    issue = Issue.new if issue.nil?
    issue.key = key
    issue.issuetype = issuetype['name']
    issue.issueicon = issuetype['iconUrl']
    issue.issuetypeid = issuetype['id'].to_i
    issue.summary = summary
    issue.customfield_11802 = send(Team.find_by_board_id(sprint_board_id).estimated) unless sprint_board_id.blank?
    issue.closed_in = parse_closed_sprints? ? parse_closed_sprints : sprint['self'] unless (sprint.blank? && closedSprints.blank?)
    issue.customfield_11382 = number_of_sprints
    issue.description = description
    issue.priority = priority['name'] unless priority.blank?
    issue.priorityicon = priority['iconUrl'] unless priority.blank?
    issue.components = components.map {|elem| elem['name']}.join(",")
    issue.status = status['statusCategory']['key']
    issue.statusname = status['statusCategory']['name']
    issue.assignee = assignee['displayName'] unless assignee.blank?
    issue.assigneeavatar = assignee['avatarUrls']['32x32'] unless assignee.blank?
    issue.created = created
    issue.updated = updated
    issue.resolutiondate = resolutiondate
    issue.histories = parse_histories unless histories.blank?
    issue
  end

  protected

  def parse_closed_sprints?
    (sprint.blank? && closedSprints.present?)
  end

  def number_of_sprints
    return 0 if closedSprints.blank?
    closedSprints.count.to_i
  end

  private

  def parse_histories
    items = []
    histories.each_with_index.map {|elem, index|
      if index.zero? || (['status', 'Flagged', 'Component'].include? elem['items'].first['field'])
        items << elem
      end
    }.compact
    items
  end

  def parse_closed_sprints
    closedSprints.sort {|x, y| Time.parse(x['completeDate']) <=> Time.parse(y['completeDate'])}.last['self'] unless closedSprints.blank?
  end

  def sprint_board_id
    return sprint['originBoardId'] unless sprint.blank?
    return closedSprints.first['originBoardId'] unless closedSprints.blank?
  end

  #Seems that once the jira issue is created all data is lost.
  def parse_issue elem
    uniq_list = (self.public_methods(false).grep(/=/) + elem['fields'].keys).uniq
    uniq_list.each {|key|
      v = nested_hash_value(elem, key.to_s.chomp('='))
      accesor_builder key, v
    }
  end
end