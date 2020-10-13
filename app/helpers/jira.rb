require 'jira-ruby'
require_relative 'file'
module Jira

  class Client
    @instance

    attr_reader :agile_url, :greenhopper_url, :instance

    def initialize(user)
      @instance = self.class.instance(user)
      @agile_url = Vortrics.config[:jira][:agile_url]
      @greenhopper_url = Vortrics.config[:jira][:green_hopper_url]
    end

    def self.instance(user)
      setting = user&.setting.presence || Connect.setting
      options = {
          site: setting.site,
          rest_base_path: setting.base_path,
          context_path: setting.context.blank? ? "" : setting.context,
          auth_type: setting.oauth? ? :oauth : :basic,
          http_debug: setting.debug?,
          signature_method: setting.signature_method,
          request_token_path: "/plugins/servlet/oauth/request-token",
          authorize_path: "/plugins/servlet/oauth/authorize",
          access_token_path: "/plugins/servlet/oauth/access-token",
          private_key_file: File.create_rsa_file(setting.key_data, setting.key_file),
          consumer_key: setting.consumer_key,
          username: setting.login,
          password: setting.password,
          #ssl_verify_mode: 0,
          use_ssl: setting.usessl
      }
      @instance = JIRA::Client.new(options)
      if setting.oauth?
        service = user&.services.find_by_provider(:jira)
        @instance.set_access_token(
            service.access_token,
            service.access_token_secret
        ) if service&.access_token.present?
      end
      @instance
    end

    def profile
      usr = @instance.User.singular_path(yield)
      JSON.parse(@instance.get(usr).body)
    end

    def projects
      @instance.Project.all.map {|p| Project.new(p.attrs)}
    end

    def fields
      rest_query('/field', {}, yield[:options]).map { |c| Connect::Response.new(c) }
    end

    def project_details
      args = yield
      resp = rest_query("/project/#{args[:key]}", {}, args[:options].presence)
      Connect::Response.new({key: resp.dig('key'),name: resp.dig('name'),icon: resp.dig('avatarUrls','32x32')})
    end

    def scrum
      args = yield
      agile_query("/sprint/#{args[:sprintId]}/issue", {}, args[:options])[:issues.to_s]
    end

    def kanban
      args = yield
      agile_query("/board/#{args[:boardId]}/issue", {}, args[:options])[:issues.to_s]
    end

    def boards_by_project
      args = yield
      resp = agile_query('/board', {projectKeyOrId: args[:keyorid], type: args[:type]}, args[:options])['values'].map { |c| Connect::Response.new(c) }
      args[:board].present? ? resp.find{|board| board.id.to_s.eql? args[:board]}.name : resp
    end

    def boards_by_sprint
      args = yield
      agile_query("/board/#{args[:board]}/sprint", {startAt: args[:startAt], toLast: 20}, args[:options])[:values.to_s]
    end

    def sprint_report
      args = yield
      return if args[:sprintid].blank?
      green_hopper_query('/rapid/charts/sprintreport', {rapidViewId: args[:boardid], sprintId: args[:sprintid]}, args[:options])[:contents.to_s]
    end

    def issue_attachments
      @instance.Issue.find(yield, fields: :attachment).attachments
    end

    def issue_comments
      @instance.Issue.find(yield, fields: :comment).comments.map(&:attrs)
    end

    def bugs_first_comments
      args = yield
      items = bugs_by_board { {boardid: args[:boardid], startdate: (DateTime.now - 6.months).strftime("%Y-%m-%d"), options: args[:options]} }
      items.map! {|elem| {
          priority: {icon: elem.dig('fields', 'priority', 'iconUrl'), name: elem.dig('fields', 'priority', 'name')},
          status: {icon: elem.dig('fields', 'status', 'iconUrl'), name: elem.dig('fields', 'status', 'name')},
          key: elem['key'],
          first_time: issue_comments{ elem.dig('key')}&.first,
          created: elem.dig('fields', 'created')&.to_time}
      }.delete_if {|elem| elem[:first_time].blank?}
    end

    def bugs_by_board
      args = yield
      param_hash = {issuetype: "='Bug'"}
      param_hash.merge!({created: ">='#{args[:startdate]}'"})
      param_hash.merge!({resolutiondate: "<='#{args[:enddate]}'"}) unless args[:enddate].blank?
      param_hash.merge!({status: "='#{args[:status]}'"}) unless args[:status].blank?
      agile_query("/board/#{args[:boardid]}/issue", {:jql => parse_jql_params(param_hash)}, args[:options])[:issues.to_s]
    end

    def method_missing(name, *args)
      raise Connect::MethodNotFoundError.new(name,args)
    end

    protected

    def agile_query(url, jql_param = {}, options = {})
      jql_param.update JIRA::Base.query_params_for_search(options) unless options.blank?
      json = JSON.parse(@instance.get(url_with_query_params(agile_url + url, jql_param)).body)
      if pagination?(jql_param) && !json[:isLast.to_s]
        json = agile_query(url, next_page(jql_param), {})
      end
      json
    end

    def green_hopper_query(url, jql_param = {}, options = {})
      jql_param.update JIRA::Base.query_params_for_search(options) unless options.blank?
      JSON.parse(@instance.get(url_with_query_params(greenhopper_url + url, jql_param)).body)
    end

    def rest_query(path, jql_param = {}, options = {})
      jql_param.update JIRA::Base.query_params_for_search(options) unless options.blank?
      JSON.parse(@instance.get(url_with_query_params(@instance.options[:rest_base_path] + path, jql_param)).body)
    end

    private

    def parse_jql_params(jql_param)
      jql_param.map {|k, v| "#{k}#{v}"}.join(' AND ')
    end

    def pagination? (params)
      (params.include? :toLast) && (params.include? :startAt)
    end

    def next_page(params)
      params.slice(:startAt, :toLast).transform_values! {|v| v += params[:toLast]}
    end

    def url_with_query_params(url, query_params = {})
      uri = URI.parse(url)
      uri.query = Array.wrap([uri.query, hash_to_query_string(query_params)]).compact.join('&')
      uri.to_s
    end

    def hash_to_query_string(query_params = {})
      query_params.map {|k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(Array.wrap(v).join(','))}"}.join('&')
    end
  end
end
