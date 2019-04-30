
module TeamsHelper

  def advice_messages
    return if @team.blank?
    advices = []
    ScrumMetrics.config[:advices].each_key do |key|
      advices << ScrumMetrics.config[:advices][key] if @team.send(key)
    end
    advices
  end

end
