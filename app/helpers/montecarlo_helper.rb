module MontecarloHelper
  def montecarlo_summary data
    {max_likelihood: data[1].max {|a, b| a[:y] <=> b[:y]}, confidence_at_50: data[2].select {|e| e[:y] > 50}.first, confidence_at_85: data[2].select {|e| e[:y] > 85}.first}
  end
end
