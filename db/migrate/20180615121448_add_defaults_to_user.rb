class AddDefaultsToUser < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :extuser, from: nil, to: "Guest"
    change_column_default :users, :displayName, from: nil, to: "Guest"
    change_column_default :users, :avatar, from: nil, to: "/images/tmf_1.png"


    #   change_column_default(:posts, :state, from: nil, to: "draft")

  end
end
