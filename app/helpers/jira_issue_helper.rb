module JiraIssueHelper

  class IssueBuilder
    include Binky::Struct
    alias :super_initialize :initialize

    def initialize(json = nil, estimation = nil)
      super_initialize json
      @estimation_field = estimation || ""
    end

    def to_issue
      issue = Issue.new
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

    def to_h
      {
          key: key,
          issuetype: fields.issuetype&.name,
          issueicon: fields.issuetype&.iconUrl,
          issuetypeid: fields.issuetype&.id.to_i,
          summary: fields.summary,
          closed_in: fields.sprint_info&.self,
          customfield_11382: fields.count_sprints,
          description: fields.description,
          priority: fields.priority&.name,
          priorityicon: fields.priority&.iconUrl,
          components: fields.components&.map {|elem| elem['name']}.join(","),
          status: fields.status&.statusCategory.key,
          statusname: fields.status&.statusCategory.name,
          assignee: fields.assignee&.displayName,
          assigneeavatar: fields.assignee&.avatarUrls&._32x32,
          created: created_at,
          updated: fields.updated,
          resolutiondate: fields.resolutiondate,
          histories: transitions,
          customfield_11802: story_points
      }.compact
    end

    def transitions
      changelog&.histories.map.with_index {|e, idx|
        keep_log_if(e, idx) {|valid|
          break if valid['items'].blank?
          ChangeLog.new.build_by_keys(valid,ChangeLog.column_names) do |e|
            e.to_hash.merge!(attribute_from_inner_key(log,'avatar', '48x48'))
          end
        }
      }.compact
    end

    def story_points
      self.send("fields").send(@estimation_field)
    end

    def created_at
      fields&.created&.to_datetime
    end

    def resolution_date
      fields&.resolutiondate
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
      return IssueBuilder.new(closed_sprints) unless fields&.closedSprints.blank?
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

    def keep_log_if log, index = 1
      log['items'].keep_element_if 'field', Vortrics.config[:jira][:changelogfields] unless index.eql? 0
      log['items'].keep_if {|e| e.dig('fromString').present?} unless index.eql? 0
      yield log
    end

    def closed_sprints
      fields&.closedSprints.sort {|x, y| Time.parse(x['completeDate']) <=> Time.parse(y['completeDate'])}.last unless fields&.closedSprints.blank?
    end

  end
end
