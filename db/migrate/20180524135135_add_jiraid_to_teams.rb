class AddJiraidToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :jiraid, :integer,default: 0
  end
end
