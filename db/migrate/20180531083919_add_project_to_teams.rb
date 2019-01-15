class AddProjectToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :project, :string
  end
end
