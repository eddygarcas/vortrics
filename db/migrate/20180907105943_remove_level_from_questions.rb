class RemoveLevelFromQuestions < ActiveRecord::Migration[5.1]
  def change
    remove_reference :questions, :level, foreign_key: true
  end
end
