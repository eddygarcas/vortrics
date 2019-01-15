class Assesment < ApplicationRecord
  belongs_to :team
  belongs_to :maturity_framework
  has_many :answers


  def evalutaion level_id
    level = maturity_framework.levels.find(level_id)
    stars = 0
    level.q_stages.each {|stage|
      no_total = answers.joins(:question).where({questions: {q_stage_id: stage.id}}).count
      no_right = answers.joins(:question).where({questions: {q_stage_id: stage.id}, answers: {value: 1}}).count
      stars += 1 if no_right.eql? no_total
      break unless no_right.eql? no_total
    }
    stars
  end

  def create_answers
    Answer.transaction do
      maturity_framework.levels.each {|level|
        level.create_answers id
      }
    end
  end
end
