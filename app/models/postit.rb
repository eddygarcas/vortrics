class Postit < ApplicationRecord
  acts_as_list scope: :retrospective

  belongs_to :retrospective
  belongs_to :user

  validates :text, presence: true

end
