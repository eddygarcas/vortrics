class ProjectInfo < ApplicationRecord
  has_many :teams

  def self.create_data info
    project = ProjectInfo.new(key: info.key, name: info.name,icon: info.icon)
    project.save!
    project
  end
end
