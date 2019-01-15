require 'test_helper'
require_relative '../../app/models/issue'
class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue = Issue.first
  end

  test "should get index" do
    get issues_url
    assert_response :found
  end

  test "should get new" do
    get new_issue_url
    assert_response :found
  end





end
