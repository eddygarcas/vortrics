class Advice < ApplicationRecord
  has_many :team_advices, dependent: :destroy
  has_many :teams, through: :team_advices, dependent: :destroy

  has_many :actions, dependent: :destroy
  has_many :issues, through: :actions, dependent: :destroy

  has_many :comments,dependent: :destroy

  #["id", "subject", "description", "read", "completed", "type", "created_at", "updated_at"]
  validates :advice_type, presence: {message: "Every advice must contain a valid logic method."}
  validates :subject, presence: {message: "Subject field is mandatory"}
  validates :description, presence: {message: "Advice description helps team to create better improvement actions."}
  validates_inclusion_of :completed, :in => [true, false]
  validates_inclusion_of :read, :in => [true, false]

  scope :create_by_key, -> (key) {where(advice_type: key.to_s).first_or_create(Vortrics.config[:advices][key].to_h)}
  scope :create_from_params, -> (params) {where(advice_type: params['advice_type'].to_s).first_or_create(params)}

end
