json.extract! team, :id, :name, :max_capacity, :current_capacity,:jiraid,:tmf_process,:tmf_value,:tmf_quality, :created_at, :updated_at
json.url team_url(team, format: :json)
