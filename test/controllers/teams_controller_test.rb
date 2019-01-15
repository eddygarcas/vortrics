require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @team = teams(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get teams_url
    assert_redirected_to signin_path
  end

  test "should get new" do
    get new_team_url
    assert_response :found
  end


  test "should show team" do
    get team_url(@team)
    assert_response :found
  end

  test "should get edit" do
    get edit_team_url(@team)
    assert_response :found
  end

  test "should update team" do
    patch team_url(@team), params: { team: { current_capacity: @team.current_capacity, max_capacity: @team.max_capacity, name: @team.name } }
    assert_redirected_to signin_path
  end


end
