class Comment < ApplicationRecord
  belongs_to :advice, class_name: "Advice", optional: true
  belongs_to :actor, class_name: "User"
  belongs_to :postit, class_name: "Postit", optional: true


  scope :to_vue, -> (id) {where(id: id).to_json(include: :postit)}
end