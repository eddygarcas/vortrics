class AddBoardIdToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :board_id, :integer
  end
end
