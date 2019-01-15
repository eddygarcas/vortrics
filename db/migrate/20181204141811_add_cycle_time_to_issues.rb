class AddCycleTimeToIssues < ActiveRecord::Migration[5.1]
	def change
		add_column :issues, :cycle_time, :float
	end
end
