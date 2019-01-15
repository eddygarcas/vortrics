require 'test_helper'

class SprintsControllerTest < ActionDispatch::IntegrationTest
  setup do
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

  # test "should create sprint" do
  #   assert_difference('Sprint.count') do
  #     post sprints_url, params: { sprint: { bugs: @sprint.bugs, closed_points: @sprint.closed_points, name: @sprint.name, remaining_points: @sprint.remaining_points, stories: @sprint.stories, team_id: @sprint.team_id } }
  #   end
  #
  #   assert_redirected_to sprint_url(Sprint.last)
  # end

  test "should show sprint" do
    get sprint_url(@sprint)
    assert_response :found
  end

  test "should get edit" do
    get edit_sprint_url(@sprint)
    assert_response :found
  end

    # test "should update sprint" do
    #   patch sprint_url(@sprint), params: { sprint: { bugs: @sprint.bugs, closed_points: @sprint.closed_points, name: @sprint.name, remaining_points: @sprint.remaining_points, stories: @sprint.stories, team_id: @sprint.team_id } }
    #   assert_redirected_to sprint_url(@sprint)
    # end
    #
    # test "should destroy sprint" do
    #   assert_difference('Sprint.count', -1) do
    #     delete sprint_url(@sprint)
    #   end
    #
    #   assert_redirected_to sprints_url
    # end
end
