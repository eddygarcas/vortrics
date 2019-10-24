require 'active_support/all'

module JqlHelper

  def parse_jql_paramters jql_param
    jql_param.map{|k,v| "#{k}#{v}"}.join(' AND ')
  end

  def url_with_query_params(url, query_params = {})
    uri = URI.parse(url)
    uri.query = Array.wrap([uri.query,hash_to_query_string(query_params)]).compact.join('&')
    uri.to_s
  end

  def hash_to_query_string(query_params = {})
    query_params.map{ |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(Array.wrap(v).join(','))}" }.join('&')
  end

end