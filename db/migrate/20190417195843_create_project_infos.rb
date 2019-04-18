class CreateProjectInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :project_infos do |t|
      t.string :key
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
