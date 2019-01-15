json.extract! issue, :id,:key,:issuetype,:issueicon,:summary,:customfield_11802, :customfield_11382, :description,:priority,:priorityicon,:components, :status,:statusname,:assignee,:assigneeavatar,:created, :updated, :resolutiondate, :sprint_id, :created_at, :updated_at
json.url issue_url(issue, format: :json)
