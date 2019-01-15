class AddEnddateToSprint < ActiveRecord::Migration[5.1]
  def change
    add_column :sprints, :enddate, :date
  end
end
