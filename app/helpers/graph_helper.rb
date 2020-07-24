module GraphHelper

  def self.number_of_by_date issues,method,type,date = Time.now, no_stories = 0
    yday_issues = issues.select {|issue|
      issue.send(method)&.to_datetime&.yday.equal? date.yday
    }
    return (no_stories - yday_issues.count).abs unless type.eql? :points
    (no_points - yday_issues.map {|elem| elem.customfield_11802.to_i}.inject(0) {|sum, x| sum + x}).abs
  end

  def self.number_of items, date = Time.now, method = :created
    items.select {|item|
      item.send(method)&.to_datetime&.yday.equal? date.yday
    }.count
  end

end