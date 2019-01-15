require_relative '../../app/helpers/numeric'
require_relative '../../app/models/change_log'

class HomeController < ApplicationController
  layout 'sidenav'
  before_action :get_jira_client, if: :authenticate_user!
  before_action :set_dashboard, only: [:sidenav, :dashboard]
  before_action :team_session, :user_session

  def sidenav
  end

  #dashboard method should retrieve all information regarding average date from team selected. If any it should deal with the error codes produced.
  def dashboard
    @advices = Hash.new
    redirect_to teams_url and return if Team.first.nil?
    redirect_to sprint_import_url(@team.board_id) and return if @team.sprint.blank?
    advice_agent
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dashboard
    @team = dashboard_params.to_i.zero?() ? Team.find_by_name(dashboard_params.to_s) : Team.find(dashboard_params)
    flash[:info] = ScrumMetrics.config[:messages][:no_teams_available] if Team.count.to_i.zero?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dashboard_params
    session[:team_id] = params[:id] unless params[:id].blank?
  end

end
