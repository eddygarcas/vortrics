require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @team = teams(:one)
    sign_in users(:one)
  end

end
