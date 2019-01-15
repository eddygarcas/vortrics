class Level < ApplicationRecord
  belongs_to :maturity_framework
  has_many :questions
  has_many :q_stages

  def create_answers assesment_id
    return if assesment_id.blank?
    q_stages.each {|stage|
      stage.create_answers assesment_id
    }
  end
end
