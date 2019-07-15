class Workflow < ApplicationRecord
	acts_as_list
	belongs_to :setting

	has_many :cards, -> {order(position: :asc)}, dependent: :destroy
	scope :sorted, -> {where.not(position: nil).order(position: :asc)}

	def status type = :open
		cards.by_list_name(type.to_s.humanize).pluck(:name).to_a
		#yield send(type).split(',')
	end
end
