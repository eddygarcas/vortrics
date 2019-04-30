class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.references :issue, foreign_key: true
      t.references :advice, foreign_key: true

      t.timestamps
    end
  end
end
