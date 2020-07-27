module JiraIssueHelper

  class Hash
    def method_missing(name,*args)
      attribute = name.to_s
      if attribute =~ /=$/
        self[attribute.chop.to_sym] = args[0]
      else
        return self[attribute.to_sym]
      end
    end
  end

  class JiraIssue
    def initialize(json = nil,estimation = nil)
      @attributes = {}
      @estimation_field = ""
      json.each do |k, v|
        self.send("#{k}=", v)
      end unless json.blank?
      @estimation_field = estimation unless estimation.blank?
    end

    def method_missing(name, *args)
      attribute = name.to_s.start_with?(/\d/) ? "_#{name.to_s}" : name.to_s
      if attribute =~ /=$/
        if args[0].respond_to?(:key?) || args[0].is_a?(Hash)
          @attributes[attribute.chop] = JiraIssue.new(args[0])
        else
          @attributes[attribute.chop] = args[0]
        end
      else
        @attributes[attribute]
      end
    end

    def to_issue
      issue = Issue.find_by_key(key)
      issue = Issue.new if issue.nil?
      issue.key = key
      issue.issuetype = fields.issuetype&.name
      issue.issueicon = fields.issuetype&.iconUrl
      issue.issuetypeid = fields.issuetype&.id.to_i
      issue.summary = fields.summary
      issue.closed_in = fields.sprint_info&.self
      issue.customfield_11382 = fields.count_sprints
      issue.description = fields.description
      issue.priority = fields.priority&.name
      issue.priorityicon = fields.priority&.iconUrl
      issue.components = fields.components&.map {|elem| elem['name']}.join(",")
      issue.status = fields.status&.statusCategory.key
      issue.statusname = fields.status&.statusCategory.name
      issue.assignee = fields.assignee&.displayName
      issue.assigneeavatar = fields.assignee&.avatarUrls&._32x32
      issue.created = created_at
      issue.updated = fields.updated
      issue.resolutiondate = fields.resolutiondate
      issue.histories = changelog&.histories
      issue.customfield_11802 = story_points
      issue
    end

    def story_points
      self.send("fields").send(@estimation_field)
    end

    def created_at
      fields&.created&.to_datetime
    end

    def closed_in
      sprint_info&.self
    end

    def count_sprints
      return 0 if fields&.closedSprints.blank?
      fields&.closedSprints.count.to_i
    end

    def sprint_info
      return fields.sprint unless fields&.sprint.blank?
      return JiraIssue.new(closed_sprints) unless fields&.closedSprints.blank?
    end

    def selectable_for_kanban?
       !epic? && !subtask?
    end

    def epic?
      fields.issuetype.name.downcase.eql?('epic')
    end

    def task?
      !subtask? && !bug? && !epic?
    end

    def subtask?
      fields&.issuetype&.subtask
    end

    def bug?
      fields.issuetype.name.downcase.eql?('bug')
    end

    private

    def closed_sprints
      fields&.closedSprints.sort {|x, y| Time.parse(x['completeDate']) <=> Time.parse(y['completeDate'])}.last unless fields&.closedSprints.blank?
    end

  end
end
