require 'test_helper'

class WorkflowsControllerTest < ActionDispatch::IntegrationTest
	setup do
		@workflow = workflows(:one)
	end

	test "should get index" do
		get workflows_url
		assert_response 302
	end

	test "should get new" do
		get new_workflow_url
		assert_response 302
	end


	test "should show workflow" do
		get workflow_url(@workflow)
		assert_response 302
	end

	test "should get edit" do
		get edit_workflow_url(@workflow)
		assert_response 302
	end

	test "should update workflow" do
		patch workflow_url(@workflow), params: { workflow: {} }
		assert_redirected_to new_user_session_path
	end

end
