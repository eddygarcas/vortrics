class AddCompletedateToSprint < ActiveRecord::Migration[6.0]
  def change
    add_column :sprints, :completeDate, :datetime, null: true
  end
end
