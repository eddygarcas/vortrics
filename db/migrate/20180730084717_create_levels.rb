class CreateLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :levels do |t|
      t.string :name
      t.references :maturity_framework, foreign_key: true

      t.timestamps
    end
  end
end
