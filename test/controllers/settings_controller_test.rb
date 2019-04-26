require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	setup do
		sign_in FactoryBot.create(:user)
		@setting = settings(:one)
	end

	test "should get index" do
		get settings_url
		assert_response 302
	end

	test "should get new" do
		get new_setting_url
		assert_response 302
	end

	test "should get edit" do
		get edit_setting_url(@setting)
		assert_response 302
	end

	test "should update setting" do
		patch setting_url(@setting), params: { setting: { base_path: @setting.base_path, consumer_key: @setting.consumer_key, context: @setting.context, debug: @setting.debug, key_file: @setting.key_file, oauth: @setting.oauth, signature_method: @setting.signature_method, site: @setting.site } }
		assert_response 302
	end

end
