require 'jira-ruby'
require_relative 'file'
module JiraHelper

  def jira_instance(setting)
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
    instance = JIRA::Client.new(options)
    if setting.oauth?
      instance.set_access_token(session[:jira_auth]['access_token'], session[:jira_auth]['access_key']) if session[:jira_auth].present?
    end
    instance
  end

  protected

  def agile_query(client, url, jql_param = {}, options = {})
    search_url = Vortrics.config[:jira][:agile_url] + url
    jql_param.update JIRA::Base.query_params_for_search(options)
    response = client.get(url_with_query_params(search_url, jql_param))
    json = JSON.parse(response.body)
    if ((json['isLast'].to_s.eql? 'false') && (jql_param.include? :toLast))
      jql_param[:startAt] += jql_param[:toLast]
      json = agile_query(client, url, jql_param, options)
    end
    json
  end

  def green_hopper_query(client, url, jql_param = {}, options = {})
    search_url = Vortrics.config[:jira][:green_hopper_url] + url
    jql_param.update JIRA::Base.query_params_for_search(options)
    JSON.parse(client.get(url_with_query_params(search_url, jql_param)).body)
  end

  def rest_query(client, path, jql_param = {}, options = {})
    search_url = client.options[:rest_base_path] + path
    query_params = {:jql => parse_jql_params(jql_param)}
    query_params.update JIRA::Base.query_params_for_search(options)
    JSON.parse(client.get(url_with_query_params(search_url, query_params)).body)
  end

  def parse_jql_params(jql_param)
    jql_param.map{|k,v| "#{k}#{v}"}.join(' AND ')
  end

  private

  def url_with_query_params(url, query_params = {})
    uri = URI.parse(url)
    uri.query = Array.wrap([uri.query,hash_to_query_string(query_params)]).compact.join('&')
    uri.to_s
  end

  def hash_to_query_string(query_params = {})
    query_params.map{ |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(Array.wrap(v).join(','))}" }.join('&')
  end
end
