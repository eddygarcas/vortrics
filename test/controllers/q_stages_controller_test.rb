require 'test_helper'

class QStagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @q_stage = q_stages(:one)
  end

  test "should get index" do
    get q_stages_url
    assert_response :found
  end

  test "should get new" do
    get new_q_stage_url
    assert_response :found
  end



  test "should show q_stage" do
    get q_stage_url(@q_stage)
    assert_response :found
  end

  test "should get edit" do
    get edit_q_stage_url(@q_stage)
    assert_response :found
  end


end
