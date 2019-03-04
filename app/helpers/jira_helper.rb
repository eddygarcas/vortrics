require 'jira-ruby'

module JiraHelper
	include JqlHelper

	def jira_instance(setting)
		options = {
				site: setting.site,
				rest_base_path: setting.base_path,
				context_path: setting.context,
				auth_type: setting.oauth? ? :oauth : :basic,
				http_debug: setting.debug?,
				signature_method: setting.signature_method,
				request_token_path: "/plugins/servlet/oauth/request-token",
				authorize_path: "/plugins/servlet/oauth/authorize",
				access_token_path: "/plugins/servlet/oauth/access-token",
				private_key_file: File.create_rsa_file(setting.key_data, setting.key_file),
				consumer_key: setting.consumer_key,
				username: setting.login,
				password: setting.password
				# username: ENV[:EXT_SERVICE_USERNAME.to_s],
				# password: ENV[:EXT_SERVICE_PASSWORD.to_s],
				#:ssl_verify_mode => 0,
		}
		instance = JIRA::Client.new(options)
		if session[:jira_auth].present? && setting.oauth?
			instance.set_access_token(session[:jira_auth]['access_token'], session[:jira_auth]['access_key'])
		end
		instance
	end


	# Request GET: /rest/api/2/project
	def project_list
		return if current_user.setting.blank?
		Rails.cache.fetch("projects", expires_in: 7.day) {
			elems = Hash.new
			projects_array = jira_instance(current_user.setting).Project.all
			projects_array.each do |elem|
				elems[elem.attrs[:name.to_s]] = elem.attrs[:key.to_s]
			end
			elems
		}
	end

	def field_list project, options = {}
		elems = Rails.cache.fetch("field_list_#{project}", expires_in: 7.day) {
			param_hash = {}
			rest_query(jira_instance(current_user.setting), '/field', param_hash, options).map { |c| [c['name'].humanize, c['id']] }
		}
		elems.sort! { |a, b| a[0] <=> b[0] }.to_h
	end

	def project_details key, options = {}
		Rails.cache.fetch("project_information_#{key.to_s}", expires_in: 7.day) {
			param_hash = {}
			rest_query(jira_instance(current_user.setting), "/project/#{key}", param_hash, options)
		}
	end

	def user_information
		return if current_user.setting.blank?
		Rails.cache.fetch("user_jira_#{current_user.extuser}", expires_in: 7.day) {
			user = jira_instance(current_user.setting).User.singular_path(current_user.extuser)
			JSON.parse(jira_instance(current_user.setting).get(user).body)
		}
	end

	def import_sprint sprintId, options = {}
		return if current_user.setting.blank?
		elems = Rails.cache.fetch("sprint_#{sprintId}", expires_in: 2.minutes) {
			param_hash = {}
			agile_query jira_instance(current_user.setting), "/sprint/#{sprintId}/issue", param_hash, options
		}
		elems[:issues.to_s]
	end

	def issue_comments key
		return if current_user.setting.blank?
		jira_instance(current_user.setting).Issue.find(key, fields: :comment).comments
	end

	def issue_attachments key
		return if current_user.setting.blank?
		jira_instance(current_user.setting).Issue.find(key, fields: :attachment).attachment
	end

	def current_project key, options = {}
		return if current_user.setting.blank?
		elems = Rails.cache.fetch("get_current_project_#{key.to_s}", expires_in: 30.minutes) {
			param_hash = { project: "='#{key}'" }
			rest_query(jira_instance(current_user.setting), '/search', param_hash, options)
		}
		elems[:issues.to_s]
	end

	def bug_for_board boardid, startdate, options = {}, status = nil
		return if current_user.setting.blank?
		elems = Rails.cache.fetch("bug_for_board_#{boardid}_#{startdate.to_s}", expires_in: 30.minutes) {
			param_hash = { issuetype: "='Bug'" }
			param_hash.merge!({ created: ">='#{startdate}'" })
			param_hash.merge!({ status: "='#{status}'" }) unless status.blank?
			query_params = { :jql => parse_jql_paramters(param_hash) }

			agile_query jira_instance(current_user.setting), "/board/#{boardid}/issue", query_params, options
		}
		elems[:issues.to_s]
	end


	def boards_by_project key, type = 'scrum', options = {}
		return if current_user.setting.blank?
		boards = Rails.cache.fetch("project_boards_#{key.to_s}", expires_in: 7.day) {
			param_hash = { projectKeyOrId: key, type: type }
			agile_query(jira_instance(current_user.setting), '/board', param_hash, options)[:values.to_s].map { |c| [c['id'], c['name']] }
		}
		boards.to_h
	end

	def sprint_report boardid, sprintid, options = {}
		return if current_user.setting.blank?
		sprint_report = Rails.cache.fetch("sprint_report_#{sprintid.to_s}", expires_in: 1.day) {
			param_hash = { rapidViewId: boardid, sprintId: sprintid }
			greenhopper_query jira_instance(current_user.setting), '/rapid/charts/sprintreport', param_hash, options
		}
		sprint_report['contents']
	end

	def boards_by_sprint board, startAt = 0, options = {}
		return if current_user.setting.blank?
		boards_spints = Rails.cache.fetch("boards_sprints_#{board.to_s}", expires_in: 1.minute) {
			param_hash = { startAt: startAt, toLast: 20 }
			agile_query jira_instance(current_user.setting), "/board/#{board}/sprint", param_hash, options
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

	def rest_query(client, path, jql_param = {}, options = {})
		search_url = client.options[:rest_base_path] + path
		query_params = { :jql => parse_jql_paramters(jql_param) }
		query_params.update JIRA::Base.query_params_for_search(options)
		response = client.get(url_with_query_params(search_url, query_params))
		JSON.parse(response.body)
	end
end
