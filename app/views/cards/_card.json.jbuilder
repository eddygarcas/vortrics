json.extract! card, :id,:name,:position,:workflow_id, :created_at, :updated_at
json.url card_url(card, format: :json)
