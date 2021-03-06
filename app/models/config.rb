class Config < ApplicationRecord
	belongs_to :user
	belongs_to :setting

	def self.update_or_create(attributes)
		assign_or_new(attributes).save
	end

	def self.assign_or_new(attributes)
		obj = first.presence || new
		obj.assign_attributes(attributes)
		obj
	end
end
