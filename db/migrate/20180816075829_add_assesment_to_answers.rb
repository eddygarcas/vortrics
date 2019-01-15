class AddAssesmentToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :assesment, foreign_key: true

  end
end
