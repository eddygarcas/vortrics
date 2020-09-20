module TrelloIssue
  def to_issue
   Issue.new
  end

  def to_hash
    {
        key: "TRL-#{rand(999)}",
        issuetype: "Test #{rand(999)}",
        issueicon: "",
        issuetypeid: 4,
        summary: "Summary #{rand(999)}",
        closed_in: "",
        customfield_11382: count_sprints,
        description: "description",
        priority: "top",
        priorityicon: "",
        components: "WEB",
        status: "intermediate",
        statusname: "In Progress",
        assignee: "Eduard",
        assigneeavatar: "",
        created: created_at,
        updated: Time.zone.now - rand(30),
        resolutiondate: Time.zone.now,
        histories: [],
        customfield_11802: story_points
    }.compact

  end

  def transitions
  end

  def story_points
    rand(40)
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
    return 1
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

