class KanbanController < ApplicationController
  include ApplicationHelper
  layout 'sidenav'
  before_action :set_board, only: [:import_issues]
  before_action :team_session, :set_current_user
  before_action :admin_user?, only: [:index]

  def index
  end

  def show
  end

  #GET /kanban/import
  def import_issues
    redirect_to get_dashboard_path(Team.find_by_board_type(nil)), alert: "Kanban boards are no supported yet."
    #
    # options = {fields: vt_jira_issue_fields, maxResults: 200, expand: :changelog}
    # import_sprint(import_params[:id], options).each {|elem| issues << JiraIssue.new(elem).to_issue}
    #
    # issues_save = issues.select {|el| el.closed_in.include? import_params[:id] unless el.closed_in.blank?}
    # team.store_sprint(import_params, issues) {Sprint.find_by_sprint_id(import_params[:id]).save_issues issues_save}
    # Rails.cache.clear
    #
    # redirect_to sprint_import_url(import_params[:originBoardId]), notice: 'Sprint has successfully been imported.'
  end

  protected

  def set_board
    boardid = params[:board_id].blank? ? Team.first.board_id : params[:board_id]
    @team = Team.find_by_board_id(boardid)
  end
end
