class ApplicationController < ActionController::Base
  include Connect

  protect_from_forgery with: :exception
  #Will only get into JIRA if a Devise user has logged in
  #It calls get_jira_client every time a redirect is requested.
  before_action :authenticate_user!, except: [:info, :register]

  rescue_from JIRA::HTTPError, with: :render_403
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from SocketError, with: :render_401
  rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
    redirect_to signin_path
  end

  def render_401
    redirect_to landing_error_401_path
  end

  def render_404
    redirect_to root_url, flash: {warning: "Ups! The content you are try to reach doesn't exist. "}
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
    service_method(:profile,current_user.extuser) {|data|
      current_user.update(displayName: data[:displayName.to_s], avatar: data[:avatarUrls.to_s]['48x48'])
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
    redirect_to new_setting_path and return unless current_user.setting?
  end

end
