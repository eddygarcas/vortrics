class Workflow < ApplicationRecord
	belongs_to :setting

	def status type = :open
		yield send(type).split(',')
	end
end
