class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :assesment

  scope :total, -> (id) {joins(:question).where({questions: {q_stage_id: id}}).count}
  scope :right, -> (id) {joins(:question).where({questions: {q_stage_id: id}, answers: {value: 1}}).count}
end
