class AddStatusnameToIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :statusname, :string
  end
end
