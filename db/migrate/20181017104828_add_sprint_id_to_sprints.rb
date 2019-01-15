class AddSprintIdToSprints < ActiveRecord::Migration[5.1]
  def change
    add_column :sprints, :sprint_id, :integer
  end
end
