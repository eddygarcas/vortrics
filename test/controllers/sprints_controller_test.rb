require 'test_helper'
require 'mocha/minitest'
require_relative '../../app/helpers/connect'


class SprintsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user)
    ApplicationController.any_instance.stubs(:bugs_by_board).returns([])
    @sprint = FactoryBot.create(:sprint)
  end

  test "should get index" do
    get sprints_url
    assert_response :found
  end


  # test "should create sprint" do
  #   assert_difference('Sprint.count') do
  #     post sprints_url, params: { sprint: { bugs: @sprint.bugs, closed_points: @sprint.closed_points, name: @sprint.name, remaining_points: @sprint.remaining_points, stories: @sprint.stories, team_id: @sprint.team_id } }
  #   end
  #   assert_redirected_to sprints_url
  # end

  test "should retrieve project information" do
    stubs(:issue_by_project).returns(file_fixture('current_project.json').read)
    assert_equal issue_by_project(key: 'MTR-1111'), file_fixture('current_project.json').read
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
