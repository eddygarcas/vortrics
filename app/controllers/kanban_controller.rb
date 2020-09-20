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
    options = {fields: vt_jira_issue_fields, maxResults: 400, expand: :changelog}

    issues = service_method(:kanban,boardId: @team.board_id, options: options).
        map {|elem| Connect::Issue.new(elem,@team.estimated)}.
        select(&:selectable_for_kanban?).
        sort_by!(&:created_at).
        reverse!
    last60days = issues.select { |i| i.created_at >= (issues.first.created_at - 180.days)}
    @team.update_active_sprint(SprintsHelper::SprintBuilder.new(last60days,{
        sprint_id: @team.board_id,
        team_id: @team.id,
        board_type: @team.board_type,
        name: "#{@team.name} Kanban",
        enddate: Time.zone.now.to_date,
        start_date: issues.last.created_at
    }))
    @team.sprint.save_issues last60days
    Rails.cache.clear
    redirect_to sprint_path(@team.sprint), notice: "Kanban board has been updated"
  end

  protected

  def set_board
    boardid = params[:board_id].blank? ? Team.first.board_id : params[:board_id]
    @team = Team.find_by_board_id(boardid)
  end
end
