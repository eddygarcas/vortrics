class AddInprogressToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :inprogress, :datetime, null: true
    add_column :issues, :released, :datetime, null: true
  end
end
