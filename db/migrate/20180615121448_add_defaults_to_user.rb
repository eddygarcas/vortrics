class AddDefaultsToUser < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :displayName, from: nil, to: "Guest"
    change_column_default :users, :avatar, from: nil, to: "/images/voardtrix_logo.png"
  end
end
