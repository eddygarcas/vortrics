require 'test/unit'
require 'jira-ruby'
class HomeControllerTest < Test::Unit::TestCase
  include JiraHelper

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    get_jira_client
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end




  private
  def get_jira_client
    options = {
        :username => 'eduard.garcia',
        :password => 'Schibsted32',
        :site => 'https://jira.scmspain.com',
        :rest_base_path => '/rest/api/2',
        :context_path => '',
        :auth_type => :basic
    }

    @jira_client = JIRA::Client.new(options)


  end

end