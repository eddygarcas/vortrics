require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get questions_url
    assert_response :found
  end

  test "should get new" do
    get new_question_url
    assert_response :found
  end



  test "should show question" do
    get question_url(@question)
    assert_response :found
  end

  test "should get edit" do
    get edit_question_url(@question)
    assert_response :found
  end

  test "should update question" do
    patch question_url(@question), params: {question: {allow_comment: @question.allow_comment, help_text: @question.help_text, level_id: @question.level_id, question: @question.question}}
    assert_redirected_to "http://www.example.com/users/sign_in"
  end


end
