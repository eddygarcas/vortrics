require_relative '../../app/helpers/numeric'
require_relative '../../app/models/change_log'

class HomeController < ApplicationController
  layout 'sidenav'
  before_action :set_dashboard, only: [:sidenav, :dashboard, :manage_users]
  before_action :team_session
  before_action :redirect_unless_user_has_settings

  def sidenav
  end

  #dashboard method should retrieve all information regarding average date from team selected. If any it should deal with the error codes produced.
  # All redirections should happend here, so far when there is no service connection, no teams defined or team has to import a sprint to see data.
  def dashboard
    redirect_to teams_url and return unless current_user.setting.teams?
    redirect_to sprint_import_url(@team.board_id) and return if @team.no_sprint?
    redirect_to kanban_import_issues_url(@team.board_id) and return if @team.no_kanban?
    redirect_to sprint_path(@team.sprint) and return if @team.kanban?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_dashboard
    @team = dashboard_params.to_i.zero? ? Team.find_by_name(dashboard_params.to_s) : Team.find(dashboard_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dashboard_params
    session[:team_id] = params[:id] unless params[:id].blank?
  end

end
