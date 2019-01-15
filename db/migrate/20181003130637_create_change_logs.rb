class CreateChangeLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :change_logs do |t|
      t.datetime :created
      t.string :fromString
      t.string :toString
      t.references :issue, foreign_key: true

      t.timestamps
    end
  end
end
