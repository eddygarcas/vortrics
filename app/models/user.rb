class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :access, dependent: :destroy
  has_one :group, through: :access

  has_one :config, dependent: :destroy
  has_one :setting, through: :config

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :postits, dependent: :destroy
  has_many :services, dependent: :destroy

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.workflow type = :open
    Thread&.current[:user]&.setting&.workflow_tags_for(type)
  end

  def save_dependent setting_id = nil, is_admin = nil
    save
    Config.where(user_id: id).update_or_create(user_id: id, setting_id: setting_id.to_i) unless setting_id.blank?
    Access.where(user_id: id).update_or_create(user_id: id, group_id: Group.find_by_priority((is_admin ? 1 : 99).to_i).id) unless is_admin.nil?
    true
  rescue ActiveRecordError
    false
  end

  def teams
    Team.by_setting(setting&.id).presence || []
  end

  def setting?
    setting.present?
  end

  def edit_setting?
    !setting&.tokenized? || external_user? || admin?
  end

  def admin?
    return false if group.blank?
    group.priority.eql? 1
  end

  def has_setting? set_id
    return false if setting.blank?
    setting.id.eql? set_id
  end

  def guest?
    return true if group.blank?
    group.priority.eql? 99
  end

  def group?
    group.present?
  end

  def external_user?
    extuser.present?
  end

  def full_profile?
    displayName.present? && (!User.column_defaults.has_value? avatar)
  end

end
