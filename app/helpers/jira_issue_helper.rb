module JiraIssueHelper
  extend JiraHelper

  class JiraIssue
    def initialize(json = nil)
      @attributes = {}
      json.each do |k, v|
        self.send("#{k}=", v)
      end unless json.blank?
    end

    def method_missing(name, *args)
      attribute = name.to_s.start_with?(/\d/) ? "_#{name.to_s}" : name.to_s
      if attribute =~ /=$/
        if args[0].respond_to?(:key?)
          @attributes[attribute.chop] = JiraIssue.new(args[0])
        else
          @attributes[attribute.chop] = args[0]
        end
      else
        @attributes[attribute]
      end
    end

    def self.to_issue elem
      jissue = JiraIssue.new(elem)
      issue = Issue.find_by_key(jissue.key)
      issue = Issue.new if issue.nil?
      issue.key = jissue.key
      issue.issuetype = jissue.fields.issuetype&.name
      issue.issueicon = jissue.fields.issuetype&.iconUrl
      issue.issuetypeid = jissue.fields.issuetype&.id.to_i
      issue.summary = jissue.fields.summary
      issue.closed_in = jissue.fields.sprint_info&.self
      issue.customfield_11382 = jissue.fields.count_sprints
      issue.description = jissue.fields.description
      issue.priority = jissue.fields.priority&.name
      issue.priorityicon = jissue.fields.priority&.iconUrl
      issue.components = jissue.fields.components&.map {|elem| elem['name']}.join(",")
      issue.status = jissue.fields.status&.statusCategory.key
      issue.statusname = jissue.fields.status&.statusCategory.name
      issue.assignee = jissue.fields.assignee&.displayName
      issue.assigneeavatar = jissue.fields.assignee&.avatarUrls&._32x32
      issue.created = jissue.fields.created
      issue.updated = jissue.fields.updated
      issue.resolutiondate = jissue.fields.resolutiondate
      issue.histories = jissue.changelog&.histories
      issue.customfield_11802 = yield jissue if block_given?
      issue
    end

    def count_sprints
      return 0 if closedSprints.blank?
      closedSprints.count.to_i
    end

    def sprint_info
      return sprint unless sprint.blank?
      return closed_sprints unless closedSprints.blank?
    end

    def closed_sprints
      closedSprints.sort {|x, y| Time.parse(x['completeDate']) <=> Time.parse(y['completeDate'])}.last unless closedSprints.blank?
    end
  end
end
