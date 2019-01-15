require 'test_helper'

class LevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @level = levels(:one)
  end

  test "should get index" do
    get levels_url
    assert_response :found
  end

  test "should get new" do
    get new_level_url
    assert_response :found
  end



  test "should show level" do
    get level_url(@level)
    assert_response :found
  end

  test "should get edit" do
    get edit_level_url(@level)
    assert_response :found
  end


end
