class Retrospective < ApplicationRecord
  acts_as_list
  belongs_to :team
  has_many :postits, -> {order(position: :asc)}, dependent: :destroy

  scope :sorted, -> (id) {where(team_id: id ).order(position: :asc)}


end
