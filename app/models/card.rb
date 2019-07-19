class Card < ApplicationRecord
  acts_as_list scope: :workflow
  belongs_to :workflow

  scope :by_list_name, -> (name) {joins(:workflow).where({workflows: {name: name}})}

  validates :name, presence: true
  before_save :name_downcase

  def name_downcase
    self.name.downcase!
  end
end
