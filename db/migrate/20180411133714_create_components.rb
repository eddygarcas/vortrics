class CreateComponents < ActiveRecord::Migration[5.1]
  def change
    create_table :components do |t|
      t.string :name
      t.references :sprint, foreign_key: true
      t.timestamps
    end
  end
end
