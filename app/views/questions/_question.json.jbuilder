json.extract! question, :id, :question, :help_text, :allow_comment, :q_stage, :created_at, :updated_at
json.url question_url(question, format: :json)
