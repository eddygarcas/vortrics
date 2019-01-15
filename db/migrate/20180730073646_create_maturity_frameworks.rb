class CreateMaturityFrameworks < ActiveRecord::Migration[5.1]
  def change
    create_table :maturity_frameworks do |t|
      t.string :name

      t.timestamps
    end
  end
end
