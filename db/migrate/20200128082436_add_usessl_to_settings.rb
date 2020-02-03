class AddUsesslToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :usessl, :boolean
  end
end
