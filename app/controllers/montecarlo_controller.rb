class MontecarloController < ApplicationController
  layout 'sidenav'
  before_action :team_session



  def montecarlo_chart
    data = Rails.cache.fetch("montecarlo_chart#{@team.id}", expires_in: 30.minutes) {
      user_stories = @team.issues_selectable_for_graph
      lead_times = user_stories.map {|elem| elem.cycle_time.ceil}
      Montecasting::Charts.chart_montecarlo lead_times,50,5
    }
    render json: data
  end
end
