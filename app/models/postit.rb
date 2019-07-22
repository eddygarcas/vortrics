class Postit < ApplicationRecord
  acts_as_list scope: :retrospective

  belongs_to :retrospective

  validates :text, presence: true

end
