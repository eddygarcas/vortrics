require 'test_helper'
require_relative '../../app/helpers/jira_actions'

class JiraActionsTest < ActionView::TestCase
  include Devise::Test::IntegrationHelpers

  def current_user
    @current_user
  end

  def session
    @session
  end

  def create_setting
    Setting.create(
        {
            "id" => 4,
            "site" => "https://vortrics.atlassian.net",
            "base_path" => "/rest/api/3",
            "context" => "",
            "debug" => true,
            "oauth" => false,
            "login" => "edugarcas@gmail.com",
            "password" => "o6ccbg1889E3iqwMsLz3EA45",
            "name" => "Vortrics",
            "usessl" => true
        }
    )
  end


  setup do
    @current_user = FactoryBot.create(:user)
    @current_user.setting = create_setting
    sign_in @current_user
    VCR.insert_cassette(name)
    @options = {fields: Vortrics.config[:jira][:fields], maxResults: 200, expand: :changelog}
  end

  teardown do
    VCR.eject_cassette
  end

  test "Current user exist" do
    assert_not_nil current_user
  end

  test "Connection to a JIRA Cloud instance" do
    user_profile(current_user) { |data|
      assert_equal data['name'], 'eduard.garcia'
      assert_equal data['key'], 'eduard.garcia'
    }
  end

  test "Get projects form user" do
    data = project_list.first
    assert_equal data.key, "IM"
    assert_equal data.name, "VeePee - Manager"
    assert_equal data.projectTypeKey, "software"
    assert_equal data.instance_values['key'], "IM"
    assert_equal data.instance_values['name'], "VeePee - Manager"
    assert_equal data.instance_values['projectTypeKey'], "software"
  end

  test "Get project details from WORK" do
    data = project_details "VOR"
    assert_equal data['id'], "10000"
  end

  test "Get issues from an specific project" do
    data = current_project 'VOR'
    assert_not_nil data
  end

  test "Get comments from an specific issue" do
    data = issue_comments 'VOR-1'
    assert_equal data.first.dig('body')['content'][0]['content'][0]['text'], "This is a test comment, for testing purposes only"
    assert_equal data.first.dig('id'), "10011"
  end

  test "Get attachments from an specific issue" do
    data = issue_attachments 'VOR-1'
    assert_equal data.first.filename, "vertical_on_corporate_500x500px_by_logaster.png"
  end

  test "List of boards by project" do
    data = boards_by_project "VOR"
    assert_equal data.values.size, 5
    assert_instance_of Array,data.values
    assert_instance_of Hash,data.values.last[0]
    assert_equal data.values.last[0]['id'], 1
    assert_equal data.values.last[0]['name'], "VOR board"
  end

  test "Get active sprint from a jira instances for an specific board" do
    data = import_sprint 1, @options
    assert_equal data.last.dig('changelog').present?, true
    assert_equal data.last.dig('changelog','histories').present?, true
  end
end