class FixAdviceIdFromComments < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :team_advice_id, :advice_id
  end
end
