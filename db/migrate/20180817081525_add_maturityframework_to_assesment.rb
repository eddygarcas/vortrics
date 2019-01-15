class AddMaturityframeworkToAssesment < ActiveRecord::Migration[5.1]
  def change
    add_reference :assesments, :maturity_framework, foreign_key: true

  end
end
