class KanbanController < ApplicationController
  include ApplicationHelper
  layout 'sidenav'
  before_action :set_board, only: [:import_issues]
  before_action :team_session, :set_current_user
  before_action :admin_user?, only: [:index,:show]

  def index
  end

  def show
    render json: :success
  end

  #GET /kanban/import
  def import_issues
    options = {fields: vt_jira_issue_fields, maxResults: 200, expand: :changelog}

    issues = import_kanban(@team.board_id, options).
        map {|elem| JiraIssue.to_issue(elem) {|i| i.send(@team.estimated)}}.
        select(&:selectable_for_kanban?).
        sort_by!(&:created).
        reverse!

    last60days = issues.select { |i| i.created >= (issues.first.created - 60.days)}
    @team.store_sprint(last60days) { Sprint.find_by_sprint_id(@team.board_id).save_issues last60days}
    Rails.cache.clear
    redirect_to sprint_path(@team.sprint), notice: "Kanban board has been updated"
  end


  protected

  def set_board
    boardid = params[:board_id].blank? ? Team.first.board_id : params[:board_id]
    @team = Team.find_by_board_id(boardid)
  end
end