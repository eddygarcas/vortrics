require_relative '../../app/helpers/jira_helper'
require_relative '../../app/models/team'
require_relative '../models/jira_issue'

class ApplicationJob < ActiveJob::Base
  include JiraHelper
  queue_as :default

  def perform(*args)


    @jira_client = instance_jira

    sprints = Sprint.joins(:team).select('sprints.*,teams.name as team_name').where('enddate >= ? ', Time.now)

    sprints.each {|sprint|


      options = {fields: ScrumMetrics.config[:jira][:fields], maxResults: 200, expand: :changelog}
      issues = import_sprint(sprint.sprint_id, options).map {|elem| JiraIssue.to_issue(elem)}

      issues_save = issues.select {|el| el.closed_in.include? sprint.sprint_id.to_s unless el.closed_in.blank?}
      sprint.team.update_sprint(sprint, issues) {sprint.save_issues issues_save}

    }

  end


  private

  def instance_jira
    options = {
        site: ScrumMetrics.config[:jira][:site],
        rest_base_path: ScrumMetrics.config[:jira][:restbasepath],
        username: ENV[:EXT_SERVICE_USERNAME.to_s],
        password: ENV[:EXT_SERVICE_PASSWORD.to_s],
        :ssl_verify_mode => 0,
        context_path: '',
        :auth_type => :basic,
        :http_debug => true
    }
    JIRA::Client.new(options)
  end

end
