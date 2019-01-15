class AddPriorityiconToIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :priorityicon, :string
  end
end
