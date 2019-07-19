class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :team_advice_id
      t.integer :actor_id
      t.string :description
      t.timestamps
    end
  end
end
