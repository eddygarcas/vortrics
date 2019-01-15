class CreateSprints < ActiveRecord::Migration[5.1]
  def change
    create_table :sprints do |t|
      t.string :name
      t.integer :stories
      t.integer :bugs
      t.integer :closed_points
      t.integer :remaining_points
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
