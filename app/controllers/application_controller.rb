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

	def sprint_by_board board_id, sort_column, sort_direction, options = {}
		return if board_id.blank?
		@board_sprint = boards_by_sprint board_id, 0, options
		@board_sprint.sort_by! { |x| x[sort_column].blank? ? '' : x[sort_column] }
		@board_sprint.reverse! if sort_direction.eql? 'desc'
	end

	def set_current_user
		User.current = current_user
	end

	def user_session
		user = user_information
		return if user.nil?
		current_user.displayName = user[:displayName.to_s]
		current_user.active = user[:active.to_s]
		current_user.avatar = user[:avatarUrls.to_s]['48x48']
		current_user.update(displayName: user[:displayName.to_s], active: user[:active.to_s], avatar: user[:avatarUrls.to_s]['48x48'])
	end

	def admin_user?
		raise JIRA::HTTPError, "User Not Authorised" unless current_user.admin?
	end

	def team_session
		@team = current_user.teams.first if @team.blank?
		if !@team.blank? && session[:team_id] != @team.id
			id = session[:team_id].blank? ? @team.id : session[:team_id]
			@team = Team.find(id)
		end
		session[:team_id] = @team.id unless @team.blank?
		advice_messages
	end

	private

	def advice_messages
		return if @team.blank?
		ScrumMetrics.config[:advices].each_key do |key|
			@team.advices.where(advice_type: key.to_s).first_or_create(ScrumMetrics.config[:advices][key]) if @team.send(key)
		end
	end

	def get_jira_client
		return if current_user.setting.blank?
		@jira_client = jira_instance current_user.setting
		flash[:danger] = ScrumMetrics.config[:messages][:external_service_error] if @jira_client.nil?
	end

end
