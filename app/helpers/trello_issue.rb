
module TrelloIssue
  include Connect
  def to_issue
   Issue.new
  end

  def map
    assigne = service_method(:members, id: idMembers&.first) unless idMembers.empty?
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
        statusname: service_method(:lists, id: idList)&.name,
        assignee: assigne&.fullName.presence || "",
        assigneeavatar: assigne&.avatarUrl.presence || "",
        created: created_at,
        updated: dateLastActivity,
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
    Time.zone.now - rand(15)
  end

  def resolution_date
    Time.zone.now - rand(30)
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

