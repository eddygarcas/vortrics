class CreateComponentsSprints < ActiveRecord::Migration[5.1]
  def change
    create_table :components_sprints, id: false do |t|
      t.references :sprint, index: true, foreign_key: true
      t.references :component, index: true, foreign_key: true
    end
  end
end
