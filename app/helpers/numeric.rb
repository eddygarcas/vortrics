class Numeric
  def percent_of(n)
    percnt = self.to_f / n.to_f * 100.0
    percnt.nan? ? 0 : percnt
  end

  def number_of(n)
    nmbof = (self.to_f * n.to_f) / 100.0
    nmbof.nan? ? 0 : nmbof
  end
end