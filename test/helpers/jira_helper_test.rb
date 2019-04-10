require 'test/unit'
require 'date'

require_relative '../../app/helpers/jql_helper'
require_relative '../../app/helpers/jira_helper'
require_relative '../../app/helpers/array'

require_relative '../../app/models/jira_issue'
require_relative '../../app/models/change_log'


class JiraHelperTest < Test::Unit::TestCase
  include JiraHelper
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing

    @issues ||= Array.new
  end



  # Fake test


  def test_get_current_sprint
    @jira_cli = get_jira_client
    options = {
        fields: [:key, :priority, :issuetype, :status, :componentes, :customfield_11382, :summary, :customfield_11802, :timeoriginalestimate, :components, :description, :assignee, :created, :updated, :resolutiondate]
    }
    param_hash = {project: "='MTR'", component: "='Motorheads'", sprint: ' in openSprints()'}
    begin
      jira_issues = rest_query(@jira_cli, param_hash, options)


    issues = []
    jira_issues[:issues.to_s].each {|elem|
      issues << JiraIssue.new(elem)
    }
    elem = issues.select(&:done?).sort! {|x, y| x.created <=> y.created}.first
    puts elem
    assert_not_nil issues
    rescue Exception => e
      puts e.to_s
    end
  end



  def oauth_instance
    assert_not_nil outh_instance

    puts @jira_client
    request_token = @jira_client.request_token
    session[:request_token] = request_token.token
    session[:request_secret] = request_token.secret
  end

  private
  def get_jira_client
    options = {
        :username => 'eduard.garcia',
        :password => 'Schibsted32',
        :site => 'https://jira.scmspain.com',
        :rest_base_path => '/rest/api/2',
        :context_path => '',
        :auth_type => :basic,
        maxResults: 10,
        startAt: 0
    }

    @jira_client = JIRA::Client.new(options)


  end
end