class QStage < ApplicationRecord
  belongs_to :level
  has_many :questions

  def create_answers assesment_id
    return if assesment_id.blank?
    questions.each {|question|
      answer = Answer.new(question_id: question.id, assesment_id: assesment_id)
      answer.save!
    }
  end

end