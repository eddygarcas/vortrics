module Connect
  def self.included(base)
    base.include Trelo
    base.include Jira
  end

  def self.client(_class, _setting = nil)
    case _setting&.provider.presence || _class.current_user.setting.provider
    when 'trello'
      Trelo::Client.new(_class)
    else
      Jira::Client.new(_class, _setting)
    end
  end

  def projects
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{current_user.setting.site}", expires_in: 7.day) {
      Connect.client(self).instance.Project.all.map {|p| Project.new(p.attrs)}
    }
  end

  def fields(project, options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{project}", expires_in: 7.day) {
      Connect.client(self).rest_query('/field', {}, options).map {|c| [c['id'], "#{c['name'].humanize} - #{c['id']}"]}
    }.sort! {|a, b| a[1] <=> b[1]}.to_h
  end

  def project_details(key, options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{key.to_s}", expires_in: 7.day) {
      Connect.client(self).rest_query("/project/#{key}", {}, options)
    }
  end

  def profile(user)
    return if user.setting.blank?
    usr = Connect.client(self,user.setting).instance.User.singular_path(user.extuser)
    yield JSON.parse(Connect.client(self,user.setting).instance.get(usr).body)
  end

  def scrum(sprintId, options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{sprintId}", expires_in: 1.hour) {
      Connect.client(self).agile_query("/sprint/#{sprintId}/issue", {}, options)[:issues.to_s]
    }
  end

  def kanban(boardId, options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{boardId}", expires_in: 1.hour) {
      Connect.client(self).agile_query("/board/#{boardId}/issue", {}, options)[:issues.to_s]
    }
  end

  def boards_by_project(keyorid, type = '', options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{keyorid.to_s}", expires_in: 7.day) {
      Connect.client(self).agile_query('/board', {projectKeyOrId: keyorid, type: type}, options)
    }
  end

  def boards_by_sprint(board, startAt = 0, options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{board.to_s}", expires_in: 1.day) {
      Connect.client(self).agile_query( "/board/#{board}/sprint", {startAt: startAt, toLast: 20}, options)[:values.to_s]
    }
  end

  def sprint_report(boardid, sprintid, options = {})
    return if current_user.setting.blank?
    return if sprintid.blank?
    Rails.cache.fetch("#{__method__}_#{sprintid.to_s}", expires_in: 1.day) {
      Connect.client(self).green_hopper_query( '/rapid/charts/sprintreport', {rapidViewId: boardid, sprintId: sprintid}, options)[:contents.to_s]
    }
  end

  def issue_by_project(key, options = {})
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{key.to_s}", expires_in: 1.hour) {
      Connect.client(self).rest_query('/search', {:jql => parse_jql_params({project: "='#{key}'"})}, options)[:issues.to_s]
    }
  end

  def issue_attachments(key)
    return if current_user.setting.blank?
    Connect.client(self).instance.Issue.find(key, fields: :attachment).attachments
  end

  def issue_comments(key)
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{key}", expires_in: 1.day) {
      Connect.client(self).instance.Issue.find(key, fields: :comment).comments.map(&:attrs)
    }
  end

  def bugs_first_comments(board_id)
    options = {fields: vt_jira_issue_fields, maxResults: 400}
    items = bugs_by_board(board_id, (DateTime.now - 6.months).strftime("%Y-%m-%d"),nil, options)
    items.map! { |elem| {
        priority:   { icon: elem.dig('fields','priority','iconUrl'), name: elem.dig('fields','priority','name') },
        status:     { icon: elem.dig('fields','status','iconUrl'), name: elem.dig('fields','status','name')},
        key:        elem['key'],
        first_time: issue_comments(elem.dig('key'))&.first,
        created:    elem.dig('fields','created')&.to_time}
    }.delete_if { |elem| elem[:first_time].blank? }
  end

  def bugs_by_board(boardid, startdate, enddate = nil, options = {}, status = nil)
    return if current_user.setting.blank?
    Rails.cache.fetch("#{__method__}_#{boardid}_#{startdate.to_s}", expires_in: 1.day) {
      param_hash = {issuetype: "='Bug'"}
      param_hash.merge!({created: ">='#{startdate}'"})
      param_hash.merge!({resolutiondate: "<='#{enddate}'"}) unless enddate.blank?
      param_hash.merge!({status: "='#{status}'"}) unless status.blank?
      Connect.client(self).agile_query( "/board/#{boardid}/issue", {:jql => parse_jql_params(param_hash)}, options)[:issues.to_s]
    }
  end

  protected

  def parse_jql_params(jql_param)
    jql_param.map {|k, v| "#{k}#{v}"}.join(' AND ')
  end

end
