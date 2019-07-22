class Retrospective < ApplicationRecord
  acts_as_list
  belongs_to :team
  has_many :postits, -> {order(position: :asc)}, dependent: :destroy

  scope :sorted, -> {order(position: :asc)}


end
