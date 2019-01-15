module JqlHelper

  def parse_jql_paramters jql_param
    jql = ''
    index = 0
    jql_param.each do |k, v|
      jql << "#{' AND ' if index >= 1}#{k}#{v}"
      index+=1
    end
    jql
  end

  def url_with_query_params(url, query_params)
    uri = URI.parse(url)
    uri.query = uri.query.nil? ? "#{hash_to_query_string query_params}" : "#{uri.query}&#{hash_to_query_string query_params}" unless query_params.empty?
    puts uri.to_s
    uri.to_s
  end

  def hash_to_query_string(query_params)
    query_params.map do |k, v|
      CGI.escape(k.to_s) + '=' + CGI.escape(v.respond_to?(:each) ? v.join(',') : v.to_s)
    end.join('&')
  end
end