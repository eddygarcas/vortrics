json.extract! postit, :id, :text, :position, :dots, :comments, :retrospective_id,:created_at, :updated_at, :user
json.url postit_url(postit, format: :json)
