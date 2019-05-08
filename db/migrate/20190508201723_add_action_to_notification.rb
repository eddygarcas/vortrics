class AddActionToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :action, :string
  end
end
