require 'jira-ruby'

module JiraHelper
  include JqlHelper

  # Request GET: /rest/api/2/project
  def project_list
    Rails.cache.fetch("projects", expires_in: 7.day) {
      elems = Hash.new
      projects_array = @jira_client.Project.all
      projects_array.each do |elem|
        elems[elem.attrs[:name.to_s]] = elem.attrs[:key.to_s]
      end
      elems
    }
  end

  def project_details key, options = {}
    Rails.cache.fetch("project_information_#{key.to_s}", expires_in: 7.day) {
      param_hash = {}
      rest_query(@jira_client, "/project/#{key}", param_hash, options)
    }
  end

  def user_information
    Rails.cache.fetch("user_jira_#{current_user.extuser}", expires_in: 7.day) {
      user = @jira_client.User.singular_path(current_user.extuser)
      JSON.parse(@jira_client.get(user).body)
    }
  end

  def import_sprint sprintId, options = {}
    elems = Rails.cache.fetch("sprint_#{sprintId}", expires_in: 2.minutes) {
      param_hash = {}
      agile_query @jira_client, "/sprint/#{sprintId}/issue", param_hash, options
    }
    elems[:issues.to_s]
  end

  def issue_comments key
    comments = Rails.cache.fetch("issue_comments_#{key}", expires_in: 30.minutes) {
      @jira_client.Issue.find(key, fields: :comment)
    }
    comments.comments
  end

  def issue_attachments key
    attachments = Rails.cache.fetch("issue_attachments_#{key}", expires_in: 30.minutes) {
      @jira_client.Issue.find(key, fields: :attachment)
    }
    attachments.attachment
  end

  def current_project key, options = {}
    elems = Rails.cache.fetch("get_current_project_#{key.to_s}", expires_in: 30.minutes) {
      param_hash = {project: "='#{key}'"}
      rest_query(@jira_client, '/search', param_hash, options)
    }
    elems[:issues.to_s]
  end

  def bug_for_board boardid, startdate, options = {}, status = nil
    elems = Rails.cache.fetch("bug_for_board_#{boardid}_#{startdate.to_s}", expires_in: 30.minutes) {

      param_hash = {issuetype: "='Bug'"}
      param_hash.merge!({created: ">='#{startdate}'"})
      param_hash.merge!({status: "='#{status}'"}) unless status.blank?
      query_params = {:jql => parse_jql_paramters(param_hash)}

      agile_query @jira_client, "/board/#{boardid}/issue", query_params, options
    }
    elems[:issues.to_s]
  end


  def boards_by_project key, type = 'scrum', options = {}
    boards = Rails.cache.fetch("project_boards_#{key.to_s}", expires_in: 7.day) {
      param_hash = {projectKeyOrId: key, type: type}
      agile_query @jira_client, '/board', param_hash, options
    }
    boards[:values.to_s].map {|c| [c['id'], c['name']]}.to_h
  end

  def sprint_report boardid, sprintid, options = {}
    sprint_report = Rails.cache.fetch("sprint_report_#{sprintid.to_s}", expires_in: 1.day) {
      param_hash = {rapidViewId: boardid, sprintId: sprintid}
      greenhopper_query @jira_client, '/rapid/charts/sprintreport', param_hash, options
    }
    sprint_report['contents']
  end

  def boards_by_sprint board, startAt = 0, options = {}
    boards_spints = Rails.cache.fetch("boards_sprints_#{board.to_s}", expires_in: 1.minute) {
      param_hash = {startAt: startAt, toLast: 20}
      agile_query @jira_client, "/board/#{board}/sprint", param_hash, options
    }
    boards_spints['values']
  end

  private

  def agile_query(client, url, jql_param = {}, options = {})
    search_url = '/rest/agile/1.0' + url
    jql_param.update JIRA::Base.query_params_for_search(options)
    response = client.get(url_with_query_params(search_url, jql_param))
    json = JSON.parse(response.body)
    if ((json['isLast'].to_s.eql? 'false') && (jql_param.include? :toLast))
      jql_param[:startAt] += jql_param[:toLast]
      json = agile_query(client, url, jql_param, options)
    end
    json
  end

  def greenhopper_query(client, url, jql_param = {}, options = {})
    search_url = '/rest/greenhopper/1.0' + url
    jql_param.update JIRA::Base.query_params_for_search(options)
    response = client.get(url_with_query_params(search_url, jql_param))
    JSON.parse(response.body)
  end

  def rest_query(client, path, jql_param={}, options={})
    search_url = client.options[:rest_base_path] + path
    query_params = {:jql => parse_jql_paramters(jql_param)}
    query_params.update JIRA::Base.query_params_for_search(options)
    response = client.get(url_with_query_params(search_url, query_params))
    JSON.parse(response.body)
  end
end
