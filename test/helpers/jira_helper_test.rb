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

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def test_get_jira_user
    @jira_cli = get_jira_client
    user = @jira_cli.User.singular_path("eduard.garcia")

    jira_user = JSON.parse(@jira_cli.get(user).body)

    assert_not_nil jira_user
  end

  def test_get_jira_sprint
    options = {
        fields: [:key, :priority, :issuetype, :status, :componentes, :customfield_11382, :summary, :customfield_11802, :timeoriginalestimate, :components, :description]
    }
    @jira_cli = get_jira_client
    param_hash = {project: '=MTR', component: '=Motorheads', sprint: ' in openSprints()'}
    sprint = rest_query @jira_cli, param_hash, options
    sprint[:issues.to_s].each {|elem|
      @issues << JiraIssue.new(elem)
    }

    sprint_data = Hash
    @issues.first.customfield_11382.array_to_hash {
        |elem| sprint_data = elem if elem[:state.to_s] === 'ACTIVE'
    }
    puts sprint_data.to_s
    assert_equal 'ACTIVE', sprint_data[:state.to_s]
    # @jira_cli.extend Client
    # sprint = @jira_cli.Project
    # sprint.component_issues param_hash,options
    assert_not_nil sprint_data

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


  #Will pick up the story that took more time to complete.
  def test_changelog_issue
    changelog = get_jira_client.Issue.find('MTR-13949', fields: :key, expand: :changelog)

    transitions = changelog.attrs['changelog']['histories'].each_with_index.map {
        |elem, index| ChangeLog.new(elem) if (index == 0 or elem['items'].first['field'].eql? 'status')
    }.compact

    transitions.each {|transition|
      puts "Date #{transition.created} from #{transition.fromString} to #{transition.toString}"

    }

    start_time = transitions.first
    open_time = transitions.select {|x| x.toString.eql? 'Backlog'}.first
    backlog_time = transitions.select {|x| x.toString.eql? 'In Progress'}.first
    wip_time = transitions.select {|x| x.toString.eql? 'Review'}.first
    review_time = transitions.select {|x| x.toString.eql? 'Closed'}.first

    puts "Open #{backlog_time.remaining open_time}"
    puts "In Progress #{wip_time.remaining backlog_time}"
    puts "Review #{review_time.remaining wip_time}"
    puts "Lead time #{review_time.remaining start_time}"

    assert_not_nil transitions
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