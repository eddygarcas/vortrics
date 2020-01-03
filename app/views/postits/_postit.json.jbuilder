json.extract! postit, :id, :text, :position, :dots, :retrospective_id,:user,:comments,:created_at, :updated_at
json.url postit_url(postit, format: :json)
