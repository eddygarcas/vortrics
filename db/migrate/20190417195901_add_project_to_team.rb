class AddProjectToTeam < ActiveRecord::Migration[5.1]
  def change
    add_reference :teams, :project_info, foreign_key: true
  end
end
