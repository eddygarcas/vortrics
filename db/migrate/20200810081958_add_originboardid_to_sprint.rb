class AddOriginboardidToSprint < ActiveRecord::Migration[6.0]
  def change
    add_column :sprints, :originBoardId, :string
  end
end
