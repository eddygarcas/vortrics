json.extract! retrospective, :id, :name, :position, :team_id, :created_at, :updated_at, :postits
json.url retrospective_url(retrospective, format: :json)
