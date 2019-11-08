class Montecarlo
  attr_writer :number, :backlog, :focus, :iteration

  def number
    @number || 1000
  end

  def backlog
    @backlog || 50
  end

  def focus
    (@focus || 100).to_f / 100
  end

  def iteration
    @iteration || 5
  end

  def initialize(params = {})
    return unless params.dig(:montecarlo).present?
    @number = params.dig(:montecarlo).fetch(:number, 1000).to_i
    @backlog = params.dig(:montecarlo).fetch(:backlog, 50).to_i
    @focus = params.dig(:montecarlo).fetch(:focus, 100).to_i
    @iteration = params.dig(:montecarlo).fetch(:iteration, 5).to_i
  end

end
