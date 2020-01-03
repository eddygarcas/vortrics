json.extract! comment, :id, :actor, :postit, :description, :created_at, :updated_at
json.url comment_url(comment, format: :json)
