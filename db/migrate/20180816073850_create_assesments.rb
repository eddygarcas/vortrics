class CreateAssesments < ActiveRecord::Migration[5.1]
  def change
    create_table :assesments do |t|
      t.datetime :date
      t.string :name
      t.references :team, foreign_key: true
      t.timestamps
    end
  end
end