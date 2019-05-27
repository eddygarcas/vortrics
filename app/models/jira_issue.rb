require_relative '../../app/helpers/data_builder_helper'

class JiraIssue
  include DataBuilderHelper

  attr_accessor :key,:histories,:sprint,:closedSprints

  def initialize elem = nil
    parse_issue elem unless elem.nil?
  end

  #This operation will require to analize both closed and sprint due to once the sprint is finish both are comming as part of the get issues message
  def self.to_issue elem
    jissue = JiraIssue.new(elem)
    issue = Issue.find_by_key(jissue.key)
    issue = Issue.new if issue.nil?
    issue.key = jissue.key
    issue.issuetype = jissue.issuetype['name']
    issue.issueicon = jissue.issuetype['iconUrl']
    issue.issuetypeid = jissue.issuetype['id'].to_i
    issue.summary = jissue.summary
    issue.closed_in = jissue.sprint_info['self'] unless jissue.sprint_info.blank?
    issue.customfield_11382 = jissue.number_of_sprints
    issue.description = jissue.description
    issue.priority = jissue.priority['name'] unless jissue.priority.blank?
    issue.priorityicon = jissue.priority['iconUrl'] unless jissue.priority.blank?
    issue.components = jissue.components.map {|elem| elem['name']}.join(",")
    issue.status = jissue.status['statusCategory']['key']
    issue.statusname = jissue.status['statusCategory']['name']
    issue.assignee = jissue.assignee['displayName'] unless jissue.assignee.blank?
    issue.assigneeavatar = jissue.assignee['avatarUrls']['32x32'] unless jissue.assignee.blank?
    issue.created = jissue.created
    issue.updated = jissue.updated
    issue.resolutiondate = jissue.resolutiondate
    issue.histories = jissue.parse_histories unless jissue.histories.blank?
    issue.customfield_11802 = yield jissue if block_given?
    issue
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

  def number_of_sprints
    return 0 if closedSprints.blank?
    closedSprints.count.to_i
  end


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
    closedSprints.sort {|x, y| Time.parse(x['completeDate']) <=> Time.parse(y['completeDate'])}.last unless closedSprints.blank?
  end

  def sprint_info
    return sprint unless sprint.blank?
    return parse_closed_sprints unless closedSprints.blank?
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