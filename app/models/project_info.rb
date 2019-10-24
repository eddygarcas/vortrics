class ProjectInfo < ApplicationRecord
  has_many :teams

  def self.create_data info
    project = ProjectInfo.new(key: info['key'], name: info['name'],icon: info.dig('avatarUrls','32x32'))
    project.save!
    project
  end
end
