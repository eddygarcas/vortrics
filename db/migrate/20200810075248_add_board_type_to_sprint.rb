class AddBoardTypeToSprint < ActiveRecord::Migration[6.0]
  def change
    add_column :sprints, :board_type, :string, null: true
  end
end
