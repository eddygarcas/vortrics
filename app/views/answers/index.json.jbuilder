json.array! @answers do |answer|
	json.level do
		json.id answer.question.q_stage.level.id
		json.name answer.question.q_stage.level.name
	end

	json.stage do
		json.id answer.question.q_stage.id
		json.name answer.question.q_stage.name
	end
	json.question do
		json.question answer.question.question
	end
	json.answer do
		json.id answer.id
		json.type answer.field_type
		json.value answer.value
	end
end
