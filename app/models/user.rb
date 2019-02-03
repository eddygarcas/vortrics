class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
	devise :database_authenticatable,
	       :recoverable, :rememberable, :trackable, :validatable

	has_one :access
	has_one :group, through: :access

	def admin?
		return false if group.blank?
		group.priority.eql? 1
	end

	def group?
		group.present?
	end

	def external_user?
		extuser.present?
	end
end
