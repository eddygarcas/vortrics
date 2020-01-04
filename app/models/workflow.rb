class Workflow < ApplicationRecord
	acts_as_list
	belongs_to :setting

	has_many :cards, -> {order(position: :asc)}, dependent: :destroy
	scope :sorted, -> {where.not(position: nil).order(position: :asc)}

	def self.create_by_setting setting_id
		Vortrics.config[:changelog].each_with_index do |status,index|
			Workflow.create({name: status[0],position: index,setting_id: setting_id})
		end
	end

end
