class AddLevelsToQStages < ActiveRecord::Migration[5.1]
  def change
    add_reference :q_stages, :level, foreign_key: true
  end
end
