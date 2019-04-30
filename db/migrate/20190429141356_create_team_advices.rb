class CreateTeamAdvices < ActiveRecord::Migration[5.1]
  def change
    create_table :team_advices do |t|
      t.references :team, foreign_key: true
      t.references :advice, foreign_key: true

      t.timestamps
    end
  end
end
