require 'test_helper'

class AssesmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assesment = assesments(:one)
  end

  test "should get index" do
    get assesments_url
    assert_response :found
  end

  test "should get new" do
    get new_assesment_url
    assert_response :found
  end



  test "should show assesment" do
    get assesment_url(@assesment)
    assert_response :found
  end

  test "should get edit" do
    get edit_assesment_url(@assesment)
    assert_response :found
  end



end
