class AddIssueisconToIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :issueicon, :string
  end
end
