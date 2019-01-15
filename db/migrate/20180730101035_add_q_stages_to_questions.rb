class AddQStagesToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :q_stage, foreign_key: true
  end
end
