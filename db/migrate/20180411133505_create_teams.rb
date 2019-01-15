class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :max_capacity
      t.integer :current_capacity

      t.timestamps
    end
  end
end
