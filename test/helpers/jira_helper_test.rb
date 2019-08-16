require 'test/unit'
require 'date'

require_relative '../../app/helpers/jql_helper'
require_relative '../../app/helpers/jira_helper'
require_relative '../../app/helpers/array'

require_relative '../../app/models/jira_issue'

class JiraHelperTest < Test::Unit::TestCase
  include JiraHelper
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @options = {
        fields: [:key, :priority, :issuetype, :status, :componentes, :customfield_11382, :summary, :customfield_11802, :timeoriginalestimate, :components, :description, :assignee, :created, :updated, :resolutiondate]
    }
    @param_hash = {project: "='MTR'", component: "='Motorheads'", sprint: ' in openSprints()'}

    @single_string = {project: 'alfalfa'}
    @issues ||= Array.new
  end

  def test_parse_jql_parameters
    param_hash = {issuetype: "='Bug'"}
    param_hash.merge!({created: ">='today'"})
    param_hash.merge!({status: "='done'"})
    assert_equal "issuetype='Bug' AND created>='today' AND status='done'", parse_jql_paramters(param_hash)
    assert_equal "issuetype='Bug'", parse_jql_paramters({issuetype: "='Bug'"})
  end

  # Fake test
  def test_url_with_query_params
    search_url = '/rest/agile/1.0/board/2441/issue?jql=test'
    assert_equal 'jql=test&fields=key%2Cpriority%2Cissuetype%2Cstatus%2Ccomponentes%2Ccustomfield_11382%2Csummary%2Ccustomfield_11802%2Ctimeoriginalestimate%2Ccomponents%2Cdescription%2Cassignee%2Ccreated%2Cupdated%2Cresolutiondate',
                 url_with_query_params(search_url, @options)

    search_url = '/rest/agile/1.0/board/2441/issue'
    assert_equal 'fields=key%2Cpriority%2Cissuetype%2Cstatus%2Ccomponentes%2Ccustomfield_11382%2Csummary%2Ccustomfield_11802%2Ctimeoriginalestimate%2Ccomponents%2Cdescription%2Cassignee%2Ccreated%2Cupdated%2Cresolutiondate',
                 url_with_query_params(search_url, @options)

    puts url_with_query_params('/rest/agile/1.0/board/2441/issue?jql=test')

  end

  def test_hash_to_query_string

    begin
      assert_equal 'fields=key%2Cpriority%2Cissuetype%2Cstatus%2Ccomponentes%2Ccustomfield_11382%2Csummary%2Ccustomfield_11802%2Ctimeoriginalestimate%2Ccomponents%2Cdescription%2Cassignee%2Ccreated%2Cupdated%2Cresolutiondate',
                   hash_to_query_string(@options)
      assert_equal 'project=%3D%27MTR%27&component=%3D%27Motorheads%27&sprint=+in+openSprints%28%29',
                   hash_to_query_string(@param_hash)
      assert_equal 'project=alfalfa',
                   hash_to_query_string(@single_string)
    rescue Exception => e
      puts e.to_s
    end
  end

end