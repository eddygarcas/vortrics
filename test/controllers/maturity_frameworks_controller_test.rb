require 'test_helper'

class MaturityFrameworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maturity_framework = maturity_frameworks(:one)
  end

  test "should get index" do
    get maturity_frameworks_url
    assert_response :found
  end

  test "should get new" do
    get new_maturity_framework_url
    assert_response :found
  end



  test "should show maturity_framework" do
    get maturity_framework_url(@maturity_framework)
    assert_response :found
  end

  test "should get edit" do
    get edit_maturity_framework_url(@maturity_framework)
    assert_response :found
  end


end
