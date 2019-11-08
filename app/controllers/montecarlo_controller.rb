class MontecarloController < ApplicationController
  layout 'sidenav'
  before_action :team_session
  before_action :set_montecarlo_chart_criteria

  def montecarlo_chart
    criteria = Montecarlo.new(params)
    user_stories = @team.issues_selectable_for_graph
    lead_times = user_stories.map {|elem| (elem.cycle_time.ceil / criteria.focus) }
    render json: Montecasting::Charts.chart_montecarlo(lead_times, criteria.backlog, criteria.iteration)
  end

  private

  def set_montecarlo_chart_criteria
    params.permit(:montecarlo, :number, :backlog, :focus, :iteration)
  end
end
