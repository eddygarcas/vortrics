class RemoveSprintIdFromComponents < ActiveRecord::Migration[5.1]
  def change
    remove_column :components, :sprint_id, :integer
  end
end
