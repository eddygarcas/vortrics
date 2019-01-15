require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @answer = answers(:one)
  end

  test "should get index" do
    get answers_url
    assert_response :found
  end

  test "should get new" do
    get new_answer_url
    assert_response :found
  end


  test "should show answer" do
    get answer_url(@answer)
    assert_response :found
  end

  test "should get edit" do
    get edit_answer_url(@answer)
    assert_response :found
  end


end
