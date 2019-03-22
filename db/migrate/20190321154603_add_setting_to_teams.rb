class AddSettingToTeams < ActiveRecord::Migration[5.1]
  def change
    add_reference :teams, :setting, foreign_key: true
  end
end
