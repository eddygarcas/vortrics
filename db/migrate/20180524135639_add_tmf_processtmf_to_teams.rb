class AddTmfProcesstmfToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :tmf_process, :integer,default: 0
  end
end
