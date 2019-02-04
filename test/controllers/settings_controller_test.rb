require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
	setup do
		@setting = settings(:one)
	end

	test "should get index" do
		get settings_url
		assert_response :success
	end

	test "should get new" do
		get new_setting_url
		assert_response :success
	end

	test "should create setting" do
		assert_difference('Setting.count') do
			post settings_url, params: { setting: { base_path: @setting.base_path, consumer_key: @setting.consumer_key, context: @setting.context, debug: @setting.debug, key_file: @setting.key_file, oauth: @setting.oauth, signature_method: @setting.signature_method, site: @setting.site } }
		end

		assert_redirected_to setting_url(Setting.last)
	end

	test "should show setting" do
		get setting_url(@setting)
		assert_response :success
	end

	test "should get edit" do
		get edit_setting_url(@setting)
		assert_response :success
	end

	test "should update setting" do
		patch setting_url(@setting), params: { setting: { base_path: @setting.base_path, consumer_key: @setting.consumer_key, context: @setting.context, debug: @setting.debug, key_file: @setting.key_file, oauth: @setting.oauth, signature_method: @setting.signature_method, site: @setting.site } }
		assert_redirected_to setting_url(@setting)
	end

	test "should destroy setting" do
		assert_difference('Setting.count', -1) do
			delete setting_url(@setting)
		end

		assert_redirected_to settings_url
	end
end
