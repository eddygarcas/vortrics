class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
	devise :database_authenticatable,
	       :recoverable, :rememberable, :trackable, :validatable

	has_one :access, dependent: :destroy
	has_one :group, through: :access, dependent: :destroy

	has_one :config, dependent: :destroy
	has_one :setting, through: :config, dependent: :destroy

	def save_dependent setting_id = nil, is_admin = nil
		save
		Config.where(user_id: id).update_or_create(user_id: id, setting_id: setting_id.to_i) unless setting_id.blank?
		Access.where(user_id: id).update_or_create(user_id: id, group_id: Group.find_by_priority((is_admin ? 1 : 99).to_i).id) unless is_admin.blank?
		puts "#{is_admin} value #{(is_admin ? 1 : 99).to_i} and group #{Group.find_by_priority((is_admin ? 1 : 99).to_i).id}"
		true
	rescue ActiveRecordError
		false
	end

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
