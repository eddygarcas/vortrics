class TeamsController < ApplicationController
	helper_method :boards_by_team
	layout 'sidenav'
	helper_method :sort_column, :sort_direction
	before_action :set_team, only: [:show, :edit, :update, :key_results, :update_capacity, :destroy]
	before_action :get_jira_client
	before_action :team_session, except: [:show, :update, :edit, :update_capacity, :destroy]
	before_action :user_session

	# GET /teams
	# GET /teams.json
	def index
		@teams = Team.paginate(page: params[:page], per_page: 25)
	end

	# GET /teams/1/graph_points
	#This method will be called by ajax from sprint_points_graph.js
	def get_graph_data
		data = Array.new { Array.new }
		data[0] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :closed_points)
		data[1] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :remaining_points)
		data[2] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :remaining_points, :closed_points)
		data[3] = JSON.parse(Team.find(params[:id]).all_sprint_names)
		render json: data
	end

	def stories_graph_data
		data = Array.new { Array.new }
		data[0] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :stories)
		data[1] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :remainingstories)
		data[2] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :stories, :remainingstories)
		data[3] = JSON.parse(Team.find(params[:id]).all_sprint_names)
		render json: data
	end

	def stories_points_graph_data
		data = Array.new { Array.new }
		data[0] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :stories)
		data[1] = JSON.parse(Team.find(params[:id]).axis_graph_by_column :closed_points)
		data[2] = JSON.parse(Team.find(params[:id]).all_sprint_names)
		render json: data
	end

	# GET /teams/1/graph_stories
	#This method will be called by ajax from sprint_points_graph.js
	def get_graph_stories
		cycle_time_user_stories = @team.issues_selectable_for_graph.sort_by(&:resolutiondate).map { |issue| issue.cycle_time }
		render json: cycle_time_user_stories.map.with_index { |issue, index| [index, cycle_time_user_stories.take(index).average] }
	end

	# GET /teams/1/graph_bugs
	#This method will be called by ajax from sprint_points_graph.js
	def get_graph_bugs
		render json: Team.find(params[:id]).array_of_data_for_graph(:bugs)
	end

	#GET /teams/1/graph_closed_by_day
	#This method will be called by ajax from sprint_points_graph.js
	def graph_closed_by_day
		data = Rails.cache.fetch("graph_closed_by_day_team_#{@team.id}", expires_in: 30.minutes) {

			data = Array.new { Array.new }
			issues = @team.sprint.issues.select(&:task?)
			burndown = issues.count
			points = issues.map { |elem| elem.customfield_11802.to_i }.inject(0) { |sum, x| sum + x }

			#To get the amount of stories closed by an specific day, will map the whole issues array counting items chechking whether its resolutiondate matches a specific date.
			data[0] = (@team.sprint.start_date..@team.sprint.enddate).select { |day| !day.sunday? && !day.saturday? }
					          .map.with_index { |date, index| { x: index, y: GraphHelper.number_stories_by_date(issues, date) } }
			data[1] = (@team.sprint.start_date..@team.sprint.enddate).select { |day| !day.sunday? && !day.saturday? }
					          .map.with_index { |date, index| { x: index, y: date.strftime("%b %d") } }
			data[2] = (@team.sprint.start_date..@team.sprint.enddate).select { |day| !day.sunday? && !day.saturday? }
					          .map.with_index { |date, index| { x: index, y: GraphHelper.number_stories_in_progress(date, issues) } }
			data[3] = (@team.sprint.start_date..@team.sprint.enddate).select { |day| !day.sunday? && !day.saturday? }
					          .map.with_index { |date, index| { x: index, y: burndown = GraphHelper.number_stories_by_date(issues, date, burndown) } }
			data[4] = (@team.sprint.start_date..@team.sprint.enddate).select { |day| !day.sunday? && !day.saturday? }
					          .map.with_index { |date, index| { x: index, y: points = GraphHelper.number_points_by_date(issues, date, points) } }
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

			data[0] = user_stories.map.with_index { |issue, index| { x: index, y: issue.key } }
			data[1] = user_stories.map.with_index { |issue, index| { x: index, y: issue.time_in_wip } }
			data[2] = user_stories.map.with_index { |issue, index| { x: index, y: issue.flagged? } }
			data[3] = user_stories.map.with_index { |issue, index| { x: index, y: issue.first_time_pass_rate? } }
			data[4] = user_stories.map.with_index { |issue, index| { x: index, y: issue.bug? } }
			data[5] = user_stories.map.with_index { |issue, index| { x: index, y: issue.resolutiondate.strftime("%b %d") } }
			data[6] = user_stories.map.with_index { |issue, index| { x: index, y: issue.more_than_sprint? } }
			data[7] = user_stories.map.with_index { |issue, index| { x: index, y: flagged += issue.time_flagged } }
			data[8] = user_stories.map.with_index { |issue, index| { x: index, y: issue.time_to_release } }
			data[9] = user_stories.map.with_index { |issue, index| { x: index, y: stories_lead_time.take(index).average } }
			data[10] = user_stories.map.with_index { |issue, index| { x: index, y: index.percent_of(user_stories.count).round(0) } }

			data
		}
		render json: data
	end

	def cycle_time_chart
		data = Rails.cache.fetch("cycle_time_chart_#{@team.id}", expires_in: 30.minutes) {

			data = Array.new { Array.new }

			user_stories = @team.issues_selectable_for_graph

			max_index = user_stories.last.cycle_time.round(0).to_i
			lead_times = user_stories.map { |elem| elem.cycle_time.ceil }

			data[0] = [*0..max_index].map { |index| { x: index, y: lead_times.count { |elem| elem.eql? index } } }
			data[1] = [*0..max_index].map { |index| { x: index, y: index } }
			data[2] = data[0].map.with_index { |storycount, index| { x: index, y: data[0].take(index).inject(0) { |acc, elem| acc + elem[:y] }.percent_of(user_stories.count).round(1) } }

			data
		}
		render json: data
	end

	def graph_ratio_bugs_closed
		data = Rails.cache.fetch("graph_ratio_bugs_closed_#{@team.id}", expires_in: 30.minutes) {

			data = Array.new { Array.new }
			bugs = bugs_selectable_for_graph

			sum_open = 0
			sum_closed = 0

			data[2] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| { x: index, y: day.strftime("%d/%m") } }
			data[0] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| { x: index, y: sum_open += (GraphHelper.number_of(bugs, day, :created) - GraphHelper.number_of(bugs, day, :resolutiondate)) } }
			data[1] = ((DateTime.now - 3.months)..DateTime.now).map.each_with_index { |day, index| { x: index, y: sum_closed += GraphHelper.number_of(bugs, day, :resolutiondate) } }

			data
		}
		render json: data

	end

	#this method will return an array of data, the first serio will contain Bugs lead time, the second Stories Release time and the third dates
	def graph_lead_time_bugs
		data = Rails.cache.fetch("graph_lead_time_bugs_team_#{@team.id}", expires_in: 30.minutes) {
			data = Array.new { Array.new }
			bugs = bugs_selectable_for_graph
			data[0] = bugs.map.with_index { |issue, index| { x: index, y: issue.key } }
			data[1] = bugs.map.with_index { |issue, index| { x: index, y: ((issue.time_in :first, :wip, false) / 1.day).abs } }
			data[2] = bugs.map.with_index { |issue, index| { x: index, y: issue.flagged? } }
			data[3] = bugs.map.with_index { |issue, index| { x: index, y: issue.first_time_pass_rate? } }
			data[4] = bugs.map.with_index { |issue, index| { x: index, y: issue.created.strftime("%b %d") } }
			data[5] = bugs.map.with_index { |issue, index| { x: index, y: issue.more_than_sprint? } }
			data[6] = bugs.map.with_index { |issue, index| { x: index, y: issue.time_flagged } }
			data[7] = bugs.map.with_index { |issue, index| { x: index, y: issue.status.upcase } }
			data[8] = bugs.map.with_index { |bug, index| { x: index, y: bugs.take(index).map { |issue| ((issue.life_time) / 1.day).abs }.average } }
			data[9] = bugs.map.with_index { |issue, index| { x: index, y: ((issue.time_in :wip, :last, false) / 1.day).abs } }

			data
		}
		render json: data
	end

	def full_project_details
		render json: project_details(params['proj_id'])
	end

	def boards_by_team
		render json: boards_by_project(params['proj_id']).invert
	end

	def key_results
		@cycle_time_issues = @team.issues_selectable_for_graph
		@cycle_time_issues.sort_by!(&sort_column.to_sym)
		@cycle_time_issues.reverse! if sort_direction.eql? 'asc'
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
		@team.avatar = project_details(@team.project)[:avatarUrls.to_s]['32x32']
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

	# PATCH/PUT /teams/1
	# PATCH/PUT /teams/1.json
	def update
		respond_to do |format|
			@team.avatar = project_details(@team.project)[:avatarUrls.to_s]['32x32']
			if @team.update(team_params)
				format.html { redirect_to teams_path, notice: 'Team was successfully updated.' }
				format.json { render :show, status: :ok, location: @team }
			else
				format.html { render :edit }
				format.json { render json: @team.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /teams/1/update_capacity
	# PATCH/PUT /teams/1.json/update_capacity
	def update_capacity
		respond_to do |format|
			if @team.update(params.permit(:current_capacity))
				format.html { redirect_to root_path, notice: 'Team was successfully updated.' }
				format.json { render :show, status: :ok, location: @team }
			else
				format.html { redirect_to root_path, alert: "Wasn't able to update the team's capacity." }
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
		options = { fields: ScrumMetrics.config[:jira][:fields], maxResults: 200 }
		bugs = []
		bug_for_board(@team.board_id, (DateTime.now - 3.months).strftime("%Y-%m-%d"), options).each { |elem| bugs << JiraIssue.new(elem).to_issue }
		bugs.sort_by!(&:created)
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
		side_nav_info
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def team_params
		params.require(:team).permit(:name, :max_capacity, :current_capacity, :tmf_process, :tmf_value, :tmf_quality, :board_id, :project, :page, :per_page)
	end
end
