class AddProviderToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :provider, :string
  end
end
