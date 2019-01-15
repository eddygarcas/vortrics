require 'test_helper'

class ComponentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @component = components(:one)
  end

  test "should get index" do
    get components_url
    assert_response :found
  end

  test "should get new" do
    get new_component_url
    assert_response :found
  end



  test "should show component" do
    get component_url(@component)
    assert_response :found
  end

  test "should get edit" do
    get edit_component_url(@component)
    assert_response :found
  end


end
