require 'test_helper'
require 'mocha/minitest'
require_relative '../../app/helpers/jira_helper'


class SprintsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user)
    ApplicationController.any_instance.stubs(:bug_for_board).returns([])
    @sprint = sprints(:one)
  end

  test "should get index" do
    get sprints_url
    assert_response :found
  end

  test "should get new" do
    get new_sprint_url
    assert_response :found
  end

  test "should create sprint" do
    assert_difference('Sprint.count') do
      post sprints_url, params: { sprint: { bugs: @sprint.bugs, closed_points: @sprint.closed_points, name: @sprint.name, remaining_points: @sprint.remaining_points, stories: @sprint.stories, team_id: @sprint.team_id } }
    end
    assert_redirected_to sprints_url
  end

  test "should retrieve project information" do
    JiraHelper.stubs(:current_project).returns(file_fixture('current_project.json').read)
    assert_equal JiraHelper.current_project('MTR-1111'), file_fixture('current_project.json').read
  end

  test "should get edit" do
    get edit_sprint_url(@sprint)
    assert_response :found
  end

    test "should update sprint" do
      patch sprint_url(@sprint), params: { sprint: { bugs: @sprint.bugs, closed_points: @sprint.closed_points, name: @sprint.name, remaining_points: @sprint.remaining_points, stories: @sprint.stories, team_id: @sprint.team_id } }
      assert_response :found
    end

end
