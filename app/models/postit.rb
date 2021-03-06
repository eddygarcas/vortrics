class Postit < ApplicationRecord
  acts_as_list scope: :retrospective

  belongs_to :retrospective
  belongs_to :user

  has_many :comments, -> {order(created_at: :desc)}, dependent: :destroy

  validates :text, presence: true

  def advice
    self
  end

end
