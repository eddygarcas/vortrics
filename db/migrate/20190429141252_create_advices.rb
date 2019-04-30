class CreateAdvices < ActiveRecord::Migration[5.1]
  def change
    create_table :advices do |t|
      t.string :subject
      t.string :description
      t.boolean :read
      t.boolean :completed
      t.string :type

      t.timestamps
    end
  end
end
