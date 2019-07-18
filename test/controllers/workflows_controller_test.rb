require 'test_helper'

class WorkflowsControllerTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	setup do
		sign_in FactoryBot.create(:user)
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




end
