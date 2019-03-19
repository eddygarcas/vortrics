class AddEstimatedToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :estimated, :string
  end
end
