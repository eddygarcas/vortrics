module TrelloIssue
  include Connect

  def to_issue
    Issue.new
  end

  def map
    {
        key: id,
        issuetype: "task",
        issueicon: "/images/userstory.svg",
        issuetypeid: 1,
        summary: name,
        closed_in: "1",
        customfield_11382: 1,
        description: desc,
        priority: "major",
        priorityicon: "/images/major.svg",
        components: labels&.map { |elem| elem['name'] }.join(","),
        status: (badges&.dueComplete || closed) ? "done" : "indeterminate",
        statusname: status&.name&.presence || "",
        assignee: log&.last&.dig("memberCreator", "fullName").presence || "Not assigned",
        assigneeavatar: "#{log&.last&.dig("memberCreator", "avatarUrl").presence}/50.png" || log&.last&.dig("memberCreator", "initials"),
        created: log&.last&.dig("date")&.to_datetime.presence || Time.zone.now,
        updated: dateLastActivity&.to_datetime,
        resolutiondate: badges&.due,
        histories: transitions,
        customfield_11802: 1
    }.compact
  end


  def transitions
    log.map { |log|
      ChangeLog.new({
                        :created => log&.dig("date")&.to_datetime,
                        :fromString => log&.dig("data", "listBefore", "name").presence || "open",
                        :toString => log&.dig("data", "listAfter", "name").presence || "open",
                        :issue_id => id,
                        :displayName => log&.dig("memberCreator", "fullName").presence || "Not assigned",
                        :avatar => "#{log&.dig("memberCreator", "avatarUrl").presence}/50.png" || log&.dig("memberCreator", "initials")
                    })
    }.compact
  end

  def story_points
    1
  end

  def created_at
    log&.last&.dig("date")&.to_datetime.presence || Time.zone.now
  end

  def resolution_date
    badges&.due.presence || Time.zone.now
  end

  def count_sprints
    1
  end

  def selectable_for_kanban?
    true
  end

  def epic?
    false
  end

  def task?
    true
  end

  def subtask?
    false
  end

  def bug?
    false
  end

end

