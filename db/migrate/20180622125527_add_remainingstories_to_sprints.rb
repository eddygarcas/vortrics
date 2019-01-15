class AddRemainingstoriesToSprints < ActiveRecord::Migration[5.1]
  def change
    add_column :sprints, :remainingstories, :integer,default: 0
  end
end
