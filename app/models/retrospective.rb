class Retrospective < ApplicationRecord
  acts_as_list
  belongs_to :team
  has_many :postits, -> {order(position: :asc)}, dependent: :destroy

  scope :sorted, -> (id) {where(team_id: id).order(position: :asc)}

  scope :to_vue, -> (id) {where(team_id: id).order(position: :asc).to_json(
      only: [:id, :name, :position, :team_id],
      include: {postits: {
          include: [:user,comments: {include: :actor }]
      }
      }
  )
  }

end
