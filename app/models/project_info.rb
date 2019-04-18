class ProjectInfo < ApplicationRecord
  has_many :teams

  def self.create_data info
    project = ProjectInfo.new(key: info['key'], name: info[:name.to_s],icon: info[:avatarUrls.to_s]['32x32'])
    project.save!
    project
  end
end
