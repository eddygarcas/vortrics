class AddBoardTypeToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :board_type, :string
  end
end
