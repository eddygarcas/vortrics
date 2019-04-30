class Action < ApplicationRecord
  belongs_to :issue
  belongs_to :advice
end
