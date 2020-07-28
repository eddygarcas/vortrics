module JiraActions
  include JiraHelper

  def project_list
    return if current_user.setting.blank?
    Rails.cache.fetch("projects_#{current_user.setting.site}", expires_in: 7.day) {
      projects_array = jira_instance(current_user.setting).Project.all
      projects_array.map {|p| Project.new(p.attrs)}
    }
  end

  def field_list project, options = {}
    elems = Rails.cache.fetch("field_list_#{project}", expires_in: 7.day) {
      param_hash = {}
      rest_query(jira_instance(current_user.setting), '/field', param_hash, options).map {|c| [c['id'], "#{c['name'].humanize} - #{c['id']}"]}
    }
    elems.sort! {|a, b| a[1] <=> b[1]}.to_h
  end

  def project_details key, options = {}
    Rails.cache.fetch("project_information_#{key.to_s}", expires_in: 7.day) {
      param_hash = {}
      rest_query(jira_instance(current_user.setting), "/project/#{key}", param_hash, options)
    }
  end

  def current_project key, options = {}
    return if current_user.setting.blank?
    elems = Rails.cache.fetch("get_current_project_#{key.to_s}", expires_in: 1.hour) {
      param_hash = {project: "='#{key}'"}
      rest_query(jira_instance(current_user.setting), '/search', param_hash, options)
    }
    elems[:issues.to_s]
  end

  def user_profile user
    return if user.setting.blank?
    usr = jira_instance(user.setting).User.singular_path(user.extuser)
    yield JSON.parse(jira_instance(user.setting).get(usr).body)
  end

  def import_sprint sprintId, options = {}
    elems = Rails.cache.fetch("sprint_#{sprintId}", expires_in: 1.hour) {
      param_hash = {}
      agile_query jira_instance(current_user.setting), "/sprint/#{sprintId}/issue", param_hash, options
    }
    elems[:issues.to_s]
  end

  def import_kanban boardId, options = {}
    elems = Rails.cache.fetch("kanban_board#{boardId}", expires_in: 1.hour) {
      param_hash = {}
      agile_query jira_instance(current_user.setting), "/board/#{boardId}/issue", param_hash, options
    }
    elems[:issues.to_s]
  end

  def issue_first_comments board_id
    options = {fields: vt_jira_issue_fields, maxResults: 400}
    items = bug_for_board(board_id, (DateTime.now - 6.months).strftime("%Y-%m-%d"),nil, options)
    items.map! { |elem| {
        priority: { icon: elem.dig('fields','priority','iconUrl'), name: elem.dig('fields','priority','name') },
        status: { icon: elem.dig('fields','status','iconUrl'), name: elem.dig('fields','status','name')},
        key: elem['key'],
        first_time: issue_comments(elem.dig('key'))&.first,
        created: elem.dig('fields','created')&.to_time}
    }.delete_if { |elem| elem[:first_time].blank? }
  end

  def issue_comments key
    return if current_user.setting.blank?
    Rails.cache.fetch("comments_by_key_#{key}", expires_in: 1.day) {
      jira_instance(current_user.setting).Issue.find(key, fields: :comment).comments.map(&:attrs)
    }
  end

  def issue_attachments key
    return if current_user.setting.blank?
    jira_instance(current_user.setting).Issue.find(key, fields: :attachment).attachments
  end

  def bug_for_board boardid, startdate, enddate = nil, options = {}, status = nil
    return if current_user.setting.blank?
    elems = Rails.cache.fetch("bug_for_board_#{boardid}_#{startdate.to_s}", expires_in: 1.day) {
      param_hash = {issuetype: "='Bug'"}
      param_hash.merge!({created: ">='#{startdate}'"})
      param_hash.merge!({resolutiondate: "<='#{enddate}'"}) unless enddate.blank?
      param_hash.merge!({status: "='#{status}'"}) unless status.blank?
      query_params = {:jql => parse_jql_paramters(param_hash)}

      agile_query jira_instance(current_user.setting), "/board/#{boardid}/issue", query_params, options
    }
    elems[:issues.to_s]
  end

  def boards_by_project keyorid, type = '', options = {}
    return if current_user.setting.blank?
    Rails.cache.fetch("project_boards_#{keyorid.to_s}", expires_in: 7.day) {
      param_hash = {projectKeyOrId: keyorid, type: type}
      agile_query(jira_instance(current_user.setting), '/board', param_hash, options)
    }
  end

  def sprint_report boardid, sprintid, options = {}
    return if current_user.setting.blank?
    return if sprintid.blank?
    sprint_report = Rails.cache.fetch("sprint_report_#{sprintid.to_s}", expires_in: 1.day) {
      param_hash = {rapidViewId: boardid, sprintId: sprintid}
      greenhopper_query jira_instance(current_user.setting), '/rapid/charts/sprintreport', param_hash, options
    }
    sprint_report['contents']
  end

  def boards_by_sprint board, startAt = 0, options = {}
    return if current_user.setting.blank?
    boards_spints = Rails.cache.fetch("boards_sprints_#{board.to_s}", expires_in: 1.day) {
      param_hash = {startAt: startAt, toLast: 20}
      agile_query jira_instance(current_user.setting), "/board/#{board}/sprint", param_hash, options
    }
    boards_spints['values']
  end

end
