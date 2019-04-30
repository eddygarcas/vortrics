
module TeamsHelper

  def advice_messages
    return if @team.blank?
    advices = []
    advices << ScrumMetrics.config[:advices][:more_than_one_sprint] if @team.more_than_one_sprint?
    advices << ScrumMetrics.config[:advices][:estimation_over_average_closed_points] if @team.estimation_over_average_closed_points?
    advices << ScrumMetrics.config[:advices][:overcommitment] if @team.overcommitment?
    advices << ScrumMetrics.config[:advices][:has_service_types] if @team.has_service_types?
    advices << ScrumMetrics.config[:advices][:variance_volatility] if @team.stories_variance > 2
    advices
  end

end
