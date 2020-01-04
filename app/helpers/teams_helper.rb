
module TeamsHelper

  def advice_messages
    return if @team.blank?
    Vortrics.config[:advices].each_key do |key|
      @team.advices.create_by_key(key) if @team.send(key)
    end
    @team.advices
  end

end
