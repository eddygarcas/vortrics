class Comment < ApplicationRecord
  belongs_to :advice, class_name: "Advice"
  belongs_to :actor, class_name: "User"
end
