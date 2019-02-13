class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable

	has_one :access
	has_one :group, through: :access

	has_one :config
	has_one :setting, through: :config

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
