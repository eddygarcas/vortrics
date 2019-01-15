class AddTmfQualityToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :tmf_quality, :integer, default: 0
  end
end
