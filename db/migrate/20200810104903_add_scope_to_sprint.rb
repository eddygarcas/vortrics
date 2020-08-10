class AddScopeToSprint < ActiveRecord::Migration[6.0]
  def change
    add_column :sprints, :change_scope, :integer
  end
end
