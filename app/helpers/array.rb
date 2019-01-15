
class Array
  def array_to_hash
    each {|sprint|
      #the string must contain a par elements, first would be the kay and the next one the value
      #Fist step it transforma a string into an array and then creates a hash getting pairs.
      yield Hash[*sprint.chop[(sprint.index('[')+1)..-1].gsub!('=',',').split(',')]
    }
  end

  def each_sum_done key_status = [:done]
    counter = 0
    each {|issue|
      counter += yield issue if key_status.include? issue.status.to_sym
    }
    counter
  end

  def each_sum
    counter = 0
    each {|issue|
      counter += yield issue
    }
    counter
  end

  def average
    inject {|sum, el| sum + el}.to_f / size
  end

  def median
    sorted = sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

end