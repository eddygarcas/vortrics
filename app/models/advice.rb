class Advice < ApplicationRecord
  has_many :team_advices
  has_many :teams, through: :team_advices

  has_many :actions
  has_many :issues, through: :actions


  #["id", "subject", "description", "read", "completed", "type", "created_at", "updated_at"]
  validates :advice_type, presence: {message: "Every advice must contain a valid logic method."}
  validates :subject, presence: {message: "Subject field is mandatory"}
  validates :description, presence: {message: "Advice description helps team to create better improvement actions."}
  validates_inclusion_of :completed, :in => [true, false]
  validates_inclusion_of :read, :in => [true, false]

end
