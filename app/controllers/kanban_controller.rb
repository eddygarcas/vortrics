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
    pp "#{@team.name} id #{@team.id} board id #{@team.board_id} options #{options}"

    issues = import_kanban(@team.board_id, options).
        map {|elem| JiraIssue.new(elem,@team.estimated)}.
        select(&:selectable_for_kanban?).
        sort_by!(&:created_at).
        reverse!
    last60days = issues.select { |i| i.created_at >= (issues.first.created_at - 180.days)}

    sprint_data = SprintsHelper::SprintBuilder.new(issues,{
        id: @team.board_id,
        team_id: @team.id,
        board_type: @team.board_type,
        name: "#{@team.name} Kanban",
        endDate: Time.zone.now.to_date,
        startDate: issues.last.created_at
    })
    @team.update_active_sprint(sprint_data.to_sprint)
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
