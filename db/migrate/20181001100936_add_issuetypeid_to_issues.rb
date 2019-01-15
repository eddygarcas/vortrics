class AddIssuetypeidToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :issuetypeid, :integer
  end
end
