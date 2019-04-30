
module TeamsHelper

  def advice_messages
    return if @team.blank?
    ScrumMetrics.config[:advices].each_key do |key|
      @team.advices.where(advice_type: key.to_s).first_or_create(ScrumMetrics.config[:advices][key]) if @team.send(key)
    end
    @team.advices
  end

end
