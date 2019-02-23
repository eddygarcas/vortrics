json.extract! question, :id, :question, :help_text, :allow_comment, :created_at, :updated_at
json.level do
	json.id question.q_stage.level.id
	json.name question.q_stage.level.name
end
json.stage do
	json.id question.q_stage_id
	json.name question.q_stage.name
end
json.url question_url(question, format: :json)
