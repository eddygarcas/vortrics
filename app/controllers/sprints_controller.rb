class SprintsController < ApplicationController
  layout 'sidenav'
  helper_method :sort_column, :sort_direction
  before_action :set_sprint, only: [:show, :edit, :update, :destroy, :graph_closed_by_day, :graph_release_time, :refresh_issues]
  before_action :team_session, :user_session, :set_current_user
  before_action :admin_user?, only: [:index, :new, :edit, :destroy]

  # GET /sprints
  # GET /sprints.json
  def index
    @sprints = Sprint.joins(:team).select('sprints.*,teams.name as team_name').paginate(page: params[:page], per_page: 25).order("#{sort_column} #{sort_direction}").all
  end

  # GET /sprints/1
  # GET /sprints/1.json
  def show
    options = {fields: ScrumMetrics.config[:jira][:fields]}
    @bugs = []
    bug_for_board(@sprint.team.board_id, @sprint.start_date, options).each {|elem| @bugs << JiraIssue.new(elem).to_issue}
    @sprint.changed_scope(sprint_report(@sprint.team.board_id, @sprint.sprint_id)['issueKeysAddedDuringSprint'].count) unless @sprint.sprint_id.blank?
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

      options = {fields: ScrumMetrics.config[:jira][:fields]}
      bugs = []
      bug_for_board(@sprint.team.board_id, @sprint.start_date, options).each {|elem| bugs << JiraIssue.new(elem).to_issue}

      burndown = @sprint.issues.select(&:task?).count
      data[0] = (@sprint.start_date..@sprint.enddate+1).select {|day| !day.sunday? && !day.saturday?}
                    .map.with_index {|date, index| {x: index, y: GraphHelper.number_stories_by_date(@sprint.issues, date)}}
      data[1] = (@sprint.start_date..@sprint.enddate+1).select {|day| !day.sunday? && !day.saturday?}
                    .map.with_index {|date, index| {x: index, y: date.strftime("%b %d")}}
      data[2] = (@sprint.start_date..@sprint.enddate+1).select {|day| !day.sunday? && !day.saturday?}
                    .map.with_index {|date, index| {x: index, y: GraphHelper.number_of(bugs, date, :created)}}
      data[3] = (@sprint.start_date..@sprint.enddate+1).select {|day| !day.sunday? && !day.saturday?}
                    .map.with_index {|date, index| {x: index, y: burndown = GraphHelper.number_stories_by_date(@sprint.issues, date, burndown)}}
      data
    }

    render json: data
  end

  #this method will return an array of data, the first serio will contain Bugs lead time, the second Stories Release time and the third dates
  def graph_release_time
    data = Rails.cache.fetch("graph_release_time_sprint_#{@sprint.id}", expires_in: 30.minutes) {
      data = Array.new {Array.new}
      user_stories = @sprint.issues.select(&:done?).sort_by(&:resolutiondate)
      flagged = 0
      data[0] = user_stories.map.with_index {|issue, index| {x: index, y: issue.key}}
      data[1] = user_stories.map.with_index {|issue, index| {x: index, y: issue.time_in_wip}}
      data[2] = user_stories.map.with_index {|issue, index| {x: index, y: issue.flagged?}}
      data[3] = user_stories.map.with_index {|issue, index| {x: index, y: issue.first_time_pass_rate?}}
      data[4] = user_stories.map.with_index {|issue, index| {x: index, y: issue.bug?}}
      data[5] = user_stories.map.with_index {|issue, index| {x: index, y: issue.resolutiondate.strftime("%b %d")}}
      data[6] = user_stories.map.with_index {|issue, index| {x: index, y: issue.more_than_sprint?}}
      data[7] = user_stories.map.with_index {|issue, index| {x: index, y: issue.time_to_release}}
      data[8] = user_stories.map.with_index { |issue, index| { x: index, y: flagged += issue.time_flagged } }
      data[9] = data[1].map.with_index {|elem, index| {x: index, y: @sprint.team.average_time}}
      data
    }
    render json: data
  end

  #GET /sprints/import
  def import
    boardid = params[:board_id].blank? ? Team.first.board_id : params[:board_id]
    @board_sprint = []
    @board_sprint = sprint_by_board boardid, sort_column_import, sort_direction
  end

  def import_issues
    unless import_params[:id].blank?
      issues = []
      team = Team.find_by_board_id(import_params[:originBoardId])
      redirect_to sprint_import_url(import_params[:originBoardId]), alert: "Selected sprint doens't match to any team created on your system" and return if team.blank?

      options = {fields: ScrumMetrics.config[:jira][:fields] << ",#{team.estimated}", maxResults: 200, expand: :changelog}
      import_sprint(import_params[:id], options).each {|elem| issues << JiraIssue.new(elem).to_issue}

      issues_save = issues.select {|el| el.closed_in.include? import_params[:id] unless el.closed_in.blank?}
      team.store_sprint(import_params, issues) {Sprint.find_by_sprint_id(import_params[:id]).save_issues issues_save}
      Rails.cache.clear
    end
    redirect_to sprint_import_url(import_params[:originBoardId]), notice: 'Sprint has successfully been imported.'
  end

  def refresh_issues
    unless @sprint.sprint_id.blank?
      issues = []
      team = Team.find(@sprint.team_id)
      redirect_to sprint_import_url(@sprint.team_id), notice: 'Cannot find the related team.' and return if team.blank?


      options = {fields: ScrumMetrics.config[:jira][:fields], maxResults: 200, expand: :changelog}
      import_sprint(@sprint.sprint_id, options).each {|elem| issues << JiraIssue.new(elem).to_issue}

      issues_save = issues.select {|el| el.closed_in.include? @sprint.sprint_id.to_s unless el.closed_in.blank?}
      team.update_sprint(@sprint, issues) {@sprint.save_issues issues_save}
      Rails.cache.clear
    end
    redirect_to sprint_path(@sprint), notice: 'Sprint has successfully been updated.'
  end

  # POST /sprints
  # POST /sprints.json
  def create
    @sprint = Sprint.new(sprint_params)

    respond_to do |format|
      if @sprint.save
        format.html {redirect_to sprints_url, notice: 'Sprint was successfully created.'}
        format.json {render :show, status: :created, location: @sprint}
      else
        format.html {render :new}
        format.json {render json: @sprint.errors, status: :unprocessable_entity}
      end
    end
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_params
    params.permit(:id, :completeDate, :endDate, :name, :startDate, :enddate, :state, :originBoardId)
  end


  def sprint_params
    params.require(:sprint).permit(:name, :stories, :bugs, :closed_points, :remaining_points, :enddate, :remainingstories, :team_id, :sprint_id, :page, :per_page)
  end
end
