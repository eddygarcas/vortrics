class AddStartDateToSprints < ActiveRecord::Migration[5.1]
  def change
    add_column :sprints, :start_date, :date
  end
end
