class Setting < ApplicationRecord
  has_many :configs
  has_many :users, through: :configs
  has_many :workflow, dependent: :destroy
  has_one :fieldmap

  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/

  PATH_REGEXP = /\A(\/)[a-z0-9]/

  validates :name, presence: {message: "Better define a name for this connection."}
  validates :key_file, presence: {message: "OAuth requires a certification file."}, if: :oauth?
  validates :site, presence: {message: "Site cannot be blank"}
  validates :base_path, presence: {message: "Base path cannot be blank"}
  validates :site, format: {with: URL_REGEXP, message: "You provided invalid URL"}
  validates :base_path, format: {with: PATH_REGEXP, message: "You provided invalid base path"}
  validates :login, presence: {message: "Login cannot be blank using a Basic authorisation."}, unless: :oauth?
  validates :password, presence: {message: "Password cannot be blank using a Basic authorisation."}, unless: :oauth?

  def workflow_tags_for column_name
    begin
      Rails.cache.fetch("column_status_#{id}_#{column_name}", expires_in: 1.minutes) {
        workflow.where(name: column_name).first.cards.pluck(:name)
      }
    rescue NoMethodError => error
      nil
    end
  end

  def teams?
    Team.by_setting(id).present?
  end

end
