class Time
  def remaining toDate
    return 'n/d' if toDate.blank?
    intervals = [["d", 1], ["h", 24], ["m", 60]]
    elapsed = toDate.to_datetime - self.to_datetime
    interval = 1.0
    parts = intervals.collect do |name, new_interval|
      interval /= new_interval
      number, elapsed = elapsed.abs.divmod(interval)
      "#{number.to_i}#{name}" unless number.to_i == 0
    end
    "#{parts.join}"
  end

end