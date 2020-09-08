require 'test_helper'
require 'mocha/minitest'
require_relative '../../app/helpers/connect'


class SprintsControllerTest < ActionDispatch::IntegrationTest
  include Connect
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

  test "should get edit" do
    get edit_sprint_url(@sprint)
    assert_response :found
  end

    test "should update sprint" do
      patch sprint_url(@sprint), params: { sprint: { bugs: @sprint.bugs, closed_points: @sprint.closed_points, name: @sprint.name, remaining_points: @sprint.remaining_points, stories: @sprint.stories, team_id: @sprint.team_id } }
      assert_response :found
    end

end
