class AddTmfValueToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :tmf_value, :integer,default: 0
  end
end
