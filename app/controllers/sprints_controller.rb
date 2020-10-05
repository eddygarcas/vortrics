class SprintsController < ApplicationController
  include ApplicationHelper
  layout 'sidenav'
  helper_method :sort_column, :sort_direction
  before_action :set_board, only: [:import]
  before_action :set_sprint, only: [:show, :edit, :update, :destroy, :graph_closed_by_day, :graph_release_time, :refresh_issues]
  before_action :team_session, :set_current_user
  before_action :admin_user?, only: [:index, :edit, :destroy]

  # GET /sprints
  # GET /sprints.json
  def index
    @sprints = Sprint.joins(:team).select('sprints.*,teams.name as team_name').paginate(page: params[:page], per_page: 25).order("#{sort_column} #{sort_direction}").all
  end

  # GET /sprints/1
  # GET /sprints/1.json
  def show
    @bugs = service_method(:bugs_by_board,boardid: @sprint.team.board_id,startdate: @sprint.start_date, enddate: @sprint.enddate, options: {fields: :key}).map {|elem| Connect::Issue.new(elem)}
  end

  # GET /sprints/news
  def new
    @sprint = Sprint.new
  end

  # GET /sprints/1/edit
  def edit
  end

  def dashboards
  end

  #GET /sprints/1/graph_closed_by_day
  def graph_closed_by_day
    data = Rails.cache.fetch("graph_closed_by_day_sprint_#{@sprint.id}", expires_in: 30.minutes) {
      data = Array.new {Array.new}
      bugs = service_method(:bugs_by_board,boardid: @sprint.team.board_id, startdate: @sprint.start_date, enddate: @sprint.enddate, options: {fields: :created}).map {|elem| Connect::Issue.new(elem)}
      burndown = @sprint.stories + @sprint.remainingstories
      data[0] = @sprint.week_days.map.with_index {|date, index| {x: index, y: GraphHelper.number_of_by_date(@sprint.issues, :resolutiondate, :story, date)}}
      data[1] = @sprint.week_days.map.with_index {|date, index| {x: index, y: date.strftime("%b %d")}}
      data[2] = @sprint.week_days.map.with_index {|date, index| {x: index, y: GraphHelper.number_of(bugs, date, :created_at)}}
      data[3] = @sprint.week_days.map.with_index {|date, index| {x: index, y: burndown = GraphHelper.number_of_by_date(@sprint.issues, :resolutiondate, :story, date, burndown)}}
      data
    }
    render json: data
  end

  #this method will return an array of data, the first serio will contain Bugs lead time, the second Stories Release time and the third dates
  def graph_release_time
    data = Rails.cache.fetch("graph_release_time_sprint_#{@sprint.id}", expires_in: 30.minutes) {
      data = Array.new {Array.new}
      user_stories = @sprint.issues.select(&:done?).sort_by(&:resolutiondate)
      data[0] = user_stories.map.with_index {|issue, index| {x: index, y: issue.key}}
      data[1] = user_stories.map.with_index {|issue, index| {x: index, y: issue.time_in_wip}}
      data[2] = user_stories.map.with_index {|issue, index| {x: index, y: issue.flagged?}}
      data[3] = user_stories.map.with_index {|issue, index| {x: index, y: issue.first_time_pass_rate?}}
      data[4] = user_stories.map.with_index {|issue, index| {x: index, y: issue.bug?}}
      data[5] = user_stories.map.with_index {|issue, index| {x: index, y: issue.resolutiondate.strftime("%b %d")}}
      data[6] = user_stories.map.with_index {|issue, index| {x: index, y: issue.more_than_sprint?}}
      data[7] = user_stories.map.with_index {|issue, index| {x: index, y: issue.time_to_release}}
      data[8] = user_stories.map.with_index {|issue, index| {x: index, y: issue.id}}
      data
    }
    render json: data
  end

  #GET /sprints/import
  def import
    @board_sprint = service_method(:boards_by_sprint, board: @team&.board_id, startAt: 0)
    @board_sprint.sort_by! {|x| x[sort_column_import].blank? ? '' : x[sort_column_import]}
    @board_sprint.reverse! unless sort_direction.eql? 'asc'
  end

  def import_issues
    unless import_params[:sprint_id].blank?

      options = {fields: vt_jira_issue_fields, maxResults: 200, expand: :changelog}
      criteria = import_params
      criteria[:team_id] = @team.id
      criteria[:board_type] = @team.board_type
      criteria[:change_scope] = service_method(:sprint_report,boardid: @team.board_id, sprintid: criteria[:sprint_id])['issueKeysAddedDuringSprint'].count

      issues = service_method(:scrum,sprintId: criteria[:sprint_id], options: options).map {|elem| Connect::Issue.new(elem, @team.estimated)}
      issues_save = issues.select {|el| el.closed_in.include? criteria[:sprint_id] unless el.closed_in.blank?}
      sprint_data = SprintsHelper::SprintBuilder.new(issues, criteria)
      @team.update_active_sprint(sprint_data)
      @team.sprints.find_by(sprint_id: sprint_data.sprint_id).save_issues issues_save
      Rails.cache.clear

    end
    redirect_to sprint_import_url(criteria[:originBoardId]), notice: 'Sprint has successfully been imported.'
  end

  def refresh_issues
    unless @sprint.sprint_id.blank?
      redirect_to sprint_import_url(@sprint.team_id), notice: 'Cannot find the related team.' and return if @team.blank?
      options = {fields: vt_jira_issue_fields, maxResults: 200, expand: :changelog}
      issues = service_method(:scrum,sprintId: @sprint.sprint_id, options: options).map {|e| Connect::Issue.new(e, @team&.estimated)}
      issues_save = issues.select {|e| e.closed_in.include? @sprint.sprint_id.to_s unless e.closed_in.blank?}
      sprint_data = SprintsHelper::SprintBuilder.new(
          issues,
          {
              sprint_id: @team&.sprint&.sprint_id.to_s,
              team_id: @team&.id,
              board_type: @team&.board_type,
              change_scope: service_method(:sprint_report,boardid: @team.board_id, sprintid: @team&.sprint&.sprint_id.to_s)['issueKeysAddedDuringSprint'].count
          }
      ).to_h.compact
      @sprint.update(sprint_data)
      @sprint.save_issues issues_save
      Rails.cache.clear
    end
    redirect_to sprint_path(@sprint), notice: 'Sprint has successfully been updated.'
  end

  # PATCH/PUT /sprints/1
  # PATCH/PUT /sprints/1.json
  def update
    respond_to do |format|
      if @sprint.update(sprint_params)
        format.html {redirect_to sprints_path, notice: 'Sprint was successfully updated.'}
        format.json {render :show, status: :ok, location: @sprint}
      else
        format.html {render :edit}
        format.json {render json: @sprint.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.json
  def destroy
    @sprint.destroy
    respond_to do |format|
      format.html {redirect_to sprints_url, notice: 'Sprint was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def sortable_columns
    ['team_name', 'name', 'stories', 'enddate', 'startDate', 'endDate']
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : 'enddate'
  end

  def sort_column_import
    sortable_columns.include?(params[:column]) ? params[:column] : 'endDate'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sprint
    @sprint = Sprint.joins(:team).select('sprints.*,teams.name as team_name').find(params[:id])
  end

  def set_board
    @team = Team.find_by_board_id(params[:board_id].presence || Team.first&.board_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_params
    params.tap { |p| p[:start_date] = p[:startDate] }.permit(:start_date)
    params.tap { |p| p[:enddate] = p[:endDate] }.permit(:enddate)
    params.tap { |p| p[:sprint_id] = p[:id] }.permit(:sprint_id)
    params.permit(:sprint_id, :completeDate,:name, :start_date, :enddate, :originBoardId)
  end

  def sprint_params
    params.require(:sprint).permit(:name, :stories, :bugs, :closed_points, :remaining_points, :enddate, :remainingstories, :team_id, :sprint_id, :page, :per_page)
  end
end
