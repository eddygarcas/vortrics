class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :help_text
      t.boolean :allow_comment
      t.references :level, foreign_key: true
      t.timestamps
    end
  end
end
