require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @team = teams(:one)
    sign_in users(:one)
  end

  test "should show team" do
    get team_url(@team)
    assert_response :success
  end



end
