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
    redirect_to root_url, flash: {warning: "Ups! #{params[:id]} doesn't exist. "}
  end

  def render_403
    redirect_to "/403.html"
  end

  protected


  def side_nav_info
    @total_teams = Team.all.count
    @project_list = project_list unless @jira_client.blank?
    @project_name = ScrumMetrics.config['name']
    @project_icon = '/images/voardtrix_logo.png'
    @boards = { name: 'None' }
    project_information unless @project_list.blank?

  end


  def sprint_by_board board_id, sort_column, sort_direction, options = {}
    return if board_id.blank?
    @board_sprint = boards_by_sprint board_id, 0, options
    @board_sprint.sort_by! {|x| x[sort_column].blank? ? '' : x[sort_column]}
    @board_sprint.reverse! if sort_direction.eql? 'desc'
  end

  def project_information
    project = @team.blank? ? @project_list.values[0] : @team.project
    options = {fields: [:project], maxResults: 1}
    issue = JiraIssue.new(current_project(project, options).first)
    @project_name = issue.project.blank? ? 'n/d' : issue.project[:name.to_s]
    @project_icon = issue.project.blank? ? '' : issue.project[:avatarUrls.to_s]['32x32']
    @boards = boards_by_project project

  end


  def user_session
    return if @jira_client.nil?
    user = user_information
    current_user.displayName = user[:displayName.to_s]
    current_user.active = user[:active.to_s]
    current_user.avatar = user[:avatarUrls.to_s]['48x48']
    current_user.update(displayName: user[:displayName.to_s], active: user[:active.to_s], avatar: user[:avatarUrls.to_s]['48x48'])
  end

  def admin_user?
    raise JIRA::HTTPError, "User Not Authorised" unless current_user.admin?
  end

  def team_session
    @team = Team.first if @team.blank?
    if !@team.blank? && session[:team_id] != @team.id
      id = session[:team_id].blank? ? @team.id : session[:team_id]
      @team = Team.find(id)
    end
    session[:team_id] = @team.id unless @team.blank?
    side_nav_info
  end


  def advice_agent
    return if @jira_client.nil?
    advices = []
    advices << ScrumMetrics.config[:messages][:more_than_sprint] if @team.sprint.issues.any?(&:more_than_sprint?)
    advices << ScrumMetrics.config[:messages][:estimation_over_average_closed_points] if @team.estimation_over_average_closed_points?
    advices << ScrumMetrics.config[:messages][:overcommitment] if @team.overcommitment?
    advices << ScrumMetrics.config[:messages][:has_service_types] if @team.has_service_types?
    advices << ScrumMetrics.config[:messages][:variance_volatility] if @team.stories_variance > 2

    session[:agent] = advices
  end

  private

  def get_jira_client
    return if current_user.setting.blank?
    @setting = current_user.setting
    @jira_client = jira_client_instance @setting
    jira_session if @setting.oauth?

    flash[:danger] = ScrumMetrics.config[:messages][:external_service_error] if @jira_client.nil?
  end


  def jira_client_instance(setting)
    options = {
        site: setting.site,
        rest_base_path: setting.base_path,
        context_path: setting.context,
        auth_type: setting.oauth? ? :oauth : :basic,
        http_debug: setting.debug?,
        signature_method: setting.signature_method,
        request_token_path: "/plugins/servlet/oauth/request-token",
        authorize_path: "/plugins/servlet/oauth/authorize",
        access_token_path: "/plugins/servlet/oauth/access-token",
        private_key_file: File.create_rsa_file(setting.key_data, setting.key_file),
        consumer_key: setting.consumer_key,
        username: setting.login,
        password: setting.password
        # username: ENV[:EXT_SERVICE_USERNAME.to_s],
        # password: ENV[:EXT_SERVICE_PASSWORD.to_s],
        #:ssl_verify_mode => 0,

    }
    JIRA::Client.new(options)
  end

  def jira_session
    # Add AccessToken if authorised previously.s
    if session[:jira_auth]
      @jira_client.set_access_token(
          session[:jira_auth]['access_token'],
          session[:jira_auth]['access_key']
      )
    end
  end
end
