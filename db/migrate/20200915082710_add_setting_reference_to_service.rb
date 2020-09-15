class AddSettingReferenceToService < ActiveRecord::Migration[6.0]
  def change
    add_reference :services, :setting, null: true, foreign_key: true
  end
end
