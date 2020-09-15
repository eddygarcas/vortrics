class Service < ApplicationRecord
  belongs_to :user
  has_one :setting
end
