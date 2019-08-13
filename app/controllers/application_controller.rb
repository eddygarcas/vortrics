require 'jira-ruby'
require_relative '../../app/helpers/jira_helper'
require_relative '../../app/helpers/file'

class ApplicationController < ActionController::Base
	include JiraHelper

	protect_from_forgery with: :exception
	#Will only get into JIRA if a Devise user has logged in
	#It calls get_jira_client every time a redirect is requested.
	before_action :authenticate_user!, except: [:info, :register]

	rescue_from JIRA::HTTPError, with: :render_403
	rescue_from ActiveRecord::RecordNotFound, with: :render_404
	rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
		redirect_to signin_path
	end

	def render_404
		redirect_to root_url, flash: { warning: "Ups! #{params[:id]} doesn't exist. " }
	end

	def render_403
		redirect_to "/403.html"
	end

	protected

	def broadcast_notification element
		(current_user.setting.users.uniq - [current_user]).each do |user|
			Notification.create(recipient: user, actor: current_user, action: "added", notifiable: element)
		end
	end

	def sprint_by_board board_id, sort_column, sort_direction, options = {}
		return if board_id.blank?
		board_sprint = boards_by_sprint board_id, 0, options
		board_sprint.sort_by! { |x| x[sort_column].blank? ? '' : x[sort_column] }
		return board_sprint.reverse! if sort_direction.eql? 'desc'
	end

	def set_current_user
		User.current = current_user
		user_profile(current_user) { |data|
			current_user.update(displayName: data[:displayName.to_s], active: data[:active.to_s], avatar: data[:avatarUrls.to_s]['48x48'])
		} unless current_user.full_profile?
	end

	def admin_user?
		raise JIRA::HTTPError, "User Not Authorised" unless current_user.admin?
	end

	def team_session
		begin
			@team = current_user.teams.first unless session[:team_id].present?
			session[:team_id] = @team.id unless @team.blank?
			@team = Team.find(session[:team_id])
		rescue
			return
		end
	end


	private

	def redirect_unless_user_has_settings
		redirect_to settings_path and return unless current_user.setting?
	end

	def get_jira_client
		return if current_user.setting.blank?
		@jira_client = jira_instance current_user.setting
		flash[:danger] = ScrumMetrics.config[:messages][:external_service_error] if @jira_client.nil?
	end

end
