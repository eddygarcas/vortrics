class CreatePostits < ActiveRecord::Migration[6.0]
  def change
    create_table :postits do |t|
      t.string :text
      t.integer :position
      t.integer :dots
      t.integer :comments
      t.references :retrospective, null: false, foreign_key: true

      t.timestamps
    end
  end
end
