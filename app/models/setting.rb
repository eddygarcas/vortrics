class Setting < ApplicationRecord
  #after_initialize :init
  has_many :configs, dependent: :destroy
  has_many :users, through: :configs
  has_many :workflow, dependent: :destroy
  has_many :teams, dependent: :destroy

  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/

  PATH_REGEXP = /\A(\/)[a-z0-9]/

  validates :name, presence: {message: "Better define a name for this connection."}
  validates :key_file, presence: {message: "OAuth requires a certification file."}, if: :oauth?
  validates :site, presence: {message: "Site cannot be blank"}, unless: :tokenized?
  validates :base_path, presence: {message: "Base path cannot be blank"}, unless: :tokenized?
  validates :site, format: {with: URL_REGEXP, message: "You provided invalid URL"}, unless: :tokenized?
  validates :base_path, format: {with: PATH_REGEXP, message: "You provided invalid base path"}, unless: :tokenized?
  validates :login, presence: {message: "Login cannot be blank using a Basic authorisation."}, unless: -> record {record.oauth? || record.tokenized?}
  validates :password, presence: {message: "Password cannot be blank using a Basic authorisation."}, unless: -> record {record.oauth? || record.tokenized?}

  def service
    Service.find_by_setting_id(id)
  end

  def provider
    service&.provider.presence || :jira.to_s
  end

  def tokenized?
    !provider.eql? :jira.to_s
  end

  def locked?
    oauth? || tokenized?
  end

  def workflow_tags_for column_name
    begin
      Rails.cache.fetch("column_status_#{id}_#{column_name}", expires_in: 1.minutes) {
        workflow.where(name: column_name).first.cards.pluck(:name)
      }
    rescue NoMethodError
      nil
    end
  end

  def teams?
    Team.by_setting(id).present?
  end

end
