
module TrelloIssue
  include Connect
  def to_issue
   Issue.new
  end

  def map
    {
        key: id,
        issuetype: "task",
        issueicon: "",
        issuetypeid: 1,
        summary: name,
        closed_in: "1",
        customfield_11382: 1,
        description: desc,
        priority: "major",
        priorityicon: "",
        components: labels&.map {|elem| elem['name']}.join(","),
        status: (badges&.dueComplete || closed) ? "done" : "indeterminate",
        statusname: status&.name&.presence || "",
        assignee: memberCreator&.fullName.presence || "Not assigned",
        assigneeavatar: memberCreator&.avatarUrl.presence || memberCreator&.initials,
        created: date&.to_datetime.presence || Time.zone.now,
        updated: dateLastActivity&.to_datetime,
        resolutiondate: badges&.due,
        histories: [],
        customfield_11802: 1
    }.compact
  end

  def transitions

  end

  def story_points
    1
  end

  def created_at
    date&.to_datetime.presence || Time.zone.now
  end

  def resolution_date
    badges&.due.presence || Time.zone.now
  end

  def closed_in

  end

  def count_sprints
    1
  end

  def sprint_info

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

  def keep_log_if log, index = 1
    yield log
  end

  def closed_sprints

  end
end

