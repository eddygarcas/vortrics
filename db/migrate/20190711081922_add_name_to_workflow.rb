class AddNameToWorkflow < ActiveRecord::Migration[5.1]
  def change
    add_column :workflows, :name, :string
    add_column :workflows, :position, :integer
  end
end
