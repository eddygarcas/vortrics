class AddActiveToSprint < ActiveRecord::Migration[5.1]
  def change
    add_column :sprints, :active, :boolean
  end
end
