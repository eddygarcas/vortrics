module GraphHelper
  #This method won't retrive issues data because, takes for granted that all this data has been cached previously
  def self.number_stories_by_date issues, date = Time.now, no_stories = 0
    yday_issues = issues.select {|issue|
      issue.resolutiondate&.yday.equal? date.yday if issue.task?
    }
    (no_stories - yday_issues.count).abs
  end

  def self.number_points_by_date issues, date = Time.now, no_points = 0
    yday_issues = issues.select {|issue|
      issue.resolutiondate&.yday.equal? date.yday if issue.task?
    }
    (no_points - yday_issues.map {|elem| elem.customfield_11802.to_i}.inject(0) {|sum, x| sum + x}).abs
  end

  #This method won't retrive issues data because, takes for granted that all this data has been cached previously
  def self.number_stories_in_progress issues, date = Time.now
    in_progress_issues = issues.select {|issue|
      issue.updated&.yday.equal? date.yday if issue.task?
    }
    in_progress_issues.count
  end

  def self.number_of items, date = Time.now, method = :created
    items.select {|item|
      item.send(method)&.to_datetime&.yday.equal? date.yday
    }.count
  end

end