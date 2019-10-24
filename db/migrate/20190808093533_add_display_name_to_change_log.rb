class AddDisplayNameToChangeLog < ActiveRecord::Migration[6.0]
  def change
    add_column :change_logs, :displayName, :string
    add_column :change_logs, :fieldtype, :string
    add_column :change_logs, :avatar, :string
  end
end
