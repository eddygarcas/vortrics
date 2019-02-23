json.(@assesment, :id, :date, :name, :team, :maturity_framework)

json.answers @assesment.answers do |answer|
	json.level do
		json.id answer.question.q_stage.level.id
		json.name answer.question.q_stage.level.name
	end
	json.stage do
		json.id answer.question.q_stage.id
		json.name answer.question.q_stage.name
	end
	json.question do
		json.id answer.question.id
		json.question answer.question.question
		json.answer do
			json.id answer.id
			json.value answer.value
			json.comment answer.text
		end
		end
	end
json.url assesment_url(assesment, format: :json)
