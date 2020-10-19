class ApplicationController < ActionController::Base
  include Connect
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:info, :register]

  rescue_from JIRA::HTTPError, with: :render_403
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Connect::MethodNotFoundError, with: :render_501
  rescue_from SocketError, with: :render_401
  rescue_from FloatDomainError, with: :render_generic_error
  rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
    redirect_to signin_path
  end

  def render_401
    redirect_to landing_error_401_path
  end

  def render_404
    redirect_to root_url, flash: {alert: "<strong>Ups!</strong> The content you are try to reach doesn't exist."}
  end

  def render_501 exception
    redirect_to teams_url , flash: {notice: "<strong>Ups!</strong> Action called (#{exception.method}) is not yet available for <strong>#{current_user&.setting&.provider.humanize}</strong>."}
  end

  def render_generic_error exception
    redirect_to teams_url , flash: {error: "<strong>Ups!</strong> Action called raised an error <strong>#{exception.message}</strong>."}
  end


  def render_403
    redirect_to landing_error_403_path
  end

  protected

  def broadcast_notification element
    (current_user.setting.users.uniq - [current_user]).each do |user|
      Notification.create(recipient: user, actor: current_user, action: "added", notifiable: element)
    end
  end

  def broadcast_actioncable channel, method, payload
    ActionCable.server.broadcast channel, {commit: method, payload: payload}

  end

  def set_current_user
    User.current = current_user
    data = service_method(:profile,current_user.extuser) unless (current_user.full_profile? || current_user.extuser.blank?)
    current_user.update(displayName: data[:displayName.to_s], avatar: data[:avatarUrls.to_s]['48x48']) unless data.blank?
  end

  def admin_user?
    redirect_to root_url, flash: {error: "<strong>Ups!</strong> You are not authorized to perform this action."} unless current_user.admin?
  end

  def registered_user?
    redirect_to root_url, flash: {error: "<strong>Ups!</strong> You are not authorized to modify an external service configuration."} unless current_user.registered?
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
    redirect_to new_setting_path and return unless current_user.setting?
  end

end
