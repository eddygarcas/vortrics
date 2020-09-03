require 'jira-ruby'
require_relative 'file'
module Jira
  class Client
    @instance

    attr_reader :agile_url, :greenhopper_url, :instance

    def initialize(_class, _setting = nil )
      @instance = self.class.instance(_class,_setting)
      @agile_url = Vortrics.config[:jira][:agile_url]
      @greenhopper_url = Vortrics.config[:jira][:green_hopper_url]
    end

    def self.instance(_class, _setting = nil)
      setting = _setting.presence || _class.current_user.setting
      sess = _class.session

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
        @instance.set_access_token(sess[:jira_auth]['access_token'], sess[:jira_auth]['access_key']) if sess[:jira_auth].present?
      end
      @instance
    end

    def agile_query(url, jql_param = {}, options = {})
      jql_param.update JIRA::Base.query_params_for_search(options)
      json = JSON.parse(@instance.get(url_with_query_params(agile_url << url, jql_param)).body)
      if (json['isLast'].to_s.eql? 'false') && (jql_param.include? :toLast)
        jql_param[:startAt] += jql_param[:toLast]
        json = agile_query(url, jql_param, options)
      end
      json
    end

    def green_hopper_query(url, jql_param = {}, options = {})
      jql_param.update JIRA::Base.query_params_for_search(options)
      JSON.parse(@instance.get(url_with_query_params(greenhopper_url << url, jql_param)).body)
    end

    def rest_query(path, jql_param = {}, options = {})
      jql_param.update JIRA::Base.query_params_for_search(options) unless options.empty?
      JSON.parse(@instance.get(url_with_query_params(@instance.options[:rest_base_path] << path, jql_param)).body)
    end

    private

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
