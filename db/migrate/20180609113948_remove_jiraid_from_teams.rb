class RemoveJiraidFromTeams < ActiveRecord::Migration[5.1]
  def change
    remove_column :teams, :jiraid, :integer
  end
end
