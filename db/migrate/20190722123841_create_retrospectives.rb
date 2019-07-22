class CreateRetrospectives < ActiveRecord::Migration[6.0]
  def change
    create_table :retrospectives do |t|
      t.string :name
      t.integer :position
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
