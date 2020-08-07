class TeamsController < ApplicationController
  include ApplicationHelper
  helper_method :boards_by_team
  layout 'sidenav'
  helper_method :sort_column, :sort_direction
  before_action :set_team, only: [:show, :edit, :key_results, :comulative_flow_diagram, :support, :destroy]
  before_action :team_session, except: [:show, :edit, :destroy, :key_results]
  before_action :set_current_user

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.paginate(page: params[:page], per_page: 25)
  end

  # GET /teams/1/graph_points
  def get_graph_data
    data = Array.new { Array.new }
    team = Team.find(params[:id])
    data[0] = JSON.parse(team.axis_graph_by_column :closed_points)
    data[1] = JSON.parse(team.axis_graph_by_column :remaining_points)
    data[2] = JSON.parse(team.axis_graph_by_column :remaining_points, :closed_points)
    data[3] = JSON.parse(team.all_sprint_names)
    render json: data
  end

  def stories_graph_data
    data = Array.new { Array.new }
    team = Team.find(params[:id])
    data[0] = JSON.parse(team.axis_graph_by_column :stories)
    data[1] = JSON.parse(team.axis_graph_by_column :remainingstories)
    data[2] = JSON.parse(team.axis_graph_by_column :stories, :remainingstories)
    data[3] = JSON.parse(team.all_sprint_names)
    render json: data
  end

  def stories_points_graph_data
    data = Array.new { Array.new }
    team = Team.find(params[:id])
    data[0] = JSON.parse(team.axis_graph_by_column :stories)
    data[1] = JSON.parse(team.axis_graph_by_column :closed_points)
    data[2] = JSON.parse(team.all_sprint_names)
    render json: data
  end

  # GET /teams/1/graph_stories
  def get_graph_stories
    cycle_time_user_stories = @team.issues_selectable_for_graph.sort_by(&:resolutiondate).map(&:cycle_time)
    render json: cycle_time_user_stories.map.with_index { |issue, index| [index, cycle_time_user_stories.take(index).average] }
  end

  # GET /teams/1/graph_bugs
  def get_graph_bugs
    render json: Team.find(params[:id]).array_of_data_for_graph(:bugs)
  end

  #GET /teams/1/graph_closed_by_day
  def graph_closed_by_day
    data = Rails.cache.fetch("graph_closed_by_day_team_#{@team.id}", expires_in: 30.minutes) {

      data = Array.new { Array.new }
      issues = @team.sprint.issues.select(&:task?)
      burndown = issues.count
      points = issues.map { |elem| elem.customfield_11802.to_i }.inject(0) { |sum, x| sum + x }

      #To get the amount of stories closed by an specific day, will map the whole issues array counting items chechking whether its resolutiondate matches a specific date.
      data[0] = @team.sprint.week_days.map.with_index { |date, index| {x: index, y: GraphHelper.number_of_by_date(@sprint.issues,:resolutiondate,:story,date)} }
      data[1] = @team.sprint.week_days.map.with_index { |date, index| {x: index, y: date.strftime("%b %d")} }
      data[2] = @team.sprint.week_days.map.with_index { |date, index| {x: index, y: GraphHelper.number_of(issues, date,:updated)} }
      data[3] = @team.sprint.week_days.map.with_index { |date, index| {x: index, y: burndown = GraphHelper.number_of_by_date(issues,:resolutiondate,:story,date,burndown)} }
      data[4] = @team.sprint.week_days.map.with_index { |date, index| {x: index, y: points = GraphHelper.number_of_by_date(issues,:resolutiondate,:points,date,points)} }
      data
    }
    render json: data
  end

  #this method will return an array of data, the first serio will contain Bugs lead time, the second Stories Release time and the third dates
  def graph_release_time
    data = Rails.cache.fetch("graph_release_time_team_#{@team.id}", expires_in: 30.minutes) {
      data = Array.new { Array.new }
      user_stories = @team.issues_selectable_for_graph.sort_by(&:resolutiondate)
      stories_lead_time = user_stories.map { |issue| issue.cycle_time }
      flagged = 0

      data[0] = user_stories.map.with_index { |issue, index| {x: index, y: issue.key} }
      data[1] = user_stories.map.with_index { |issue, index| {x: index, y: issue.time_in_wip} }
      data[2] = user_stories.map.with_index { |issue, index| {x: index, y: issue.flagged?} }
      data[3] = user_stories.map.with_index { |issue, index| {x: index, y: issue.first_time_pass_rate?} }
      data[4] = user_stories.map.with_index { |issue, index| {x: index, y: issue.bug?} }
      data[5] = user_stories.map.with_index { |issue, index| {x: index, y: issue.resolutiondate.strftime("%b %d")} }
      data[6] = user_stories.map.with_index { |issue, index| {x: index, y: issue.more_than_sprint?} }
      data[7] = user_stories.map.with_index { |issue, index| {x: index, y: flagged += issue.time_flagged} }
      data[8] = user_stories.map.with_index { |issue, index| {x: index, y: issue.time_to_release} }
      data[9] = user_stories.map.with_index { |issue, index| {x: index, y: stories_lead_time.take(index).average} }
      data[10] = user_stories.map.with_index { |issue, index| {x: index, y: index.percent_of(user_stories.count).round(0)} }
      data[11] = user_stories.map.with_index { |issue, index| {x: index, y: issue.id} }
      data
    }
    render json: data
  end

  def graph_time_first_response
    render json: Rails.cache.fetch("graph_time_first_response_#{@team.id}", expires_in: 1.day) {
      data = Array.new { Array.new }
      bugs = issue_first_comments @team.board_id
      average_first_time = bugs.map { |issue| ((issue[:first_time]['created']&.to_time - issue[:created]) / 1.hour).ceil }.average

      data[0] = bugs.map.with_index { |issue, index| {x: index, y: issue[:key]} }
      data[1] = bugs.map.with_index { |issue, index| {x: index, y: issue[:created]&.strftime("%b %d")} }
      data[2] = bugs.map.with_index { |issue, index| {x: index, y: ((issue[:first_time]['created']&.to_time - issue[:created]) / 1.hour).ceil} }
      data[3] = bugs.map.with_index { |issue, index| { x: index, y: average_first_time}}
      data
    }
  end

  def cycle_time_chart
    data = Rails.cache.fetch("cycle_time_chart_#{@team.id}", expires_in: 30.minutes) {
      user_stories = @team.issues_selectable_for_graph
      lead_times = user_stories.map { |elem| elem.cycle_time.ceil }
      Montecasting::Charts.chart_cycle_time lead_times
    }
    render json: data
  end

  def graph_ratio_bugs_closed
    data = Rails.cache.fetch("graph_ratio_bugs_closed_#{@team.id}", expires_in: 30.minutes) {
      data = Array.new { Array.new }
      bugs = bugs_selectable_for_graph.map { |elem| IssueBuilder.new(elem) }.sort_by!(&:created_at)
      sum_open = 0
      sum_closed = 0
      data[2] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: day.strftime("%d/%m")} }
      data[0] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: sum_open += (GraphHelper.number_of(bugs, day, :created_at) - GraphHelper.number_of(bugs, day, :resolution_date))} }
      data[1] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: sum_closed += GraphHelper.number_of(bugs, day, :resolution_date)} }
      data
    }
    render json: data
  end

  #this method will return an array of data, the first serio will contain Bugs lead time, the second Stories Release time and the third dates
  def graph_lead_time_bugs
    data = Rails.cache.fetch("graph_lead_time_bugs_team_#{@team.id}", expires_in: 30.minutes) {
      data = Array.new { Array.new }
      bugs = bugs_selectable_for_graph.map { |elem| IssueBuilder.new(elem).to_issue }.sort_by!(&:created)
      data[0] = bugs.map.with_index { |issue, index| {x: index, y: issue.key} }
      data[1] = bugs.map.with_index { |issue, index| {x: index, y: issue.time_in({toString: :first},{toString: :wip}, false).abs} }
      data[2] = bugs.map.with_index { |issue, index| {x: index, y: issue.flagged?} }
      data[3] = bugs.map.with_index { |issue, index| {x: index, y: issue.first_time_pass_rate?} }
      data[4] = bugs.map.with_index { |issue, index| {x: index, y: issue.created.strftime("%b %d")} }
      data[5] = bugs.map.with_index { |issue, index| {x: index, y: issue.more_than_sprint?} }
      data[6] = bugs.map.with_index { |issue, index| {x: index, y: issue.time_flagged} }
      data[7] = bugs.map.with_index { |issue, index| {x: index, y: issue.status.upcase} }
      data[8] = bugs.map.with_index { |issue, index| {x: index, y: bugs.take(index).map { |issue| ((issue.life_time false)).abs }.average} }
      data[9] = bugs.map.with_index { |issue, index| {x: index, y: issue.time_in({toString: :wip},{toString: :last}, false).abs} }
      data
    }
    render json: data
  end

  def graph_comulative_flow_diagram
    data = Rails.cache.fetch("graph_comulative_flow_diagram_#{@team.id}", expires_in: 30.minutes) {
      data = Array.new { Array.new }
      issues = @team.issues_selectable_for_graph.sort_by(&:resolutiondate)
      sum_open = 0
      sum_inprogress = 0
      sum_closed = 0
      data[2] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: day.strftime("%d/%m")} }
      data[3] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: sum_open += (GraphHelper.number_of(issues, day, :created))} }
      data[0] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: sum_inprogress += (GraphHelper.number_of(issues, day, :created) - GraphHelper.number_of(issues, day, :resolutiondate))} }
      data[1] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| {x: index, y: sum_closed += GraphHelper.number_of(issues, day, :resolutiondate)} }
      data[4] = data[0].map.each_with_index { |wip, index| {x: index, y: wip[:y] + data[1][index][:y]} }
      data
    }
    render json: data
  end

  def full_project_details
    render json: project_details(params['proj_id'])
  end

  def boards_by_team
    render json: boards_by_project(params['proj_id'])['values'].map { |e| Board.new(e) }
  end

  def key_results
    @cycle_time_issues = @team.issues_selectable_for_graph
    @cycle_time_issues.sort_by!(&sort_column.to_sym)
    @cycle_time_issues.reverse! if sort_direction.eql? 'asc'
  end

  def comulative_flow_diagram

  end

  def support
    @support_bugs = bugs_selectable_for_graph.map { |elem| IssueBuilder.new(elem).to_issue }.sort_by!(&:lead_time)
    @comments = issue_first_comments @team.board_id
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.project_info_id = ProjectInfo.create_data(project_details(@team.project)).id
    respond_to do |format|
      if @team.save
        format.html { redirect_to teams_url, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def bugs_selectable_for_graph
    bug_for_board(
        @team.board_id,
        (DateTime.now - 6.months).strftime("%Y-%m-%d"),
        nil,
        {fields: vt_jira_issue_fields, maxResults: 400
        }
    )
  end

  def sortable_columns
    ['resolutiondate', 'cycle_time']
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : 'cycle_time'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :max_capacity, :current_capacity, :estimated, :board_id, :board_type, :setting_id, :project, :page, :per_page)
  end
end
