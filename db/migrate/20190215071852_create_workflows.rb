class CreateWorkflows < ActiveRecord::Migration[5.1]
	def change
		create_table :workflows do |t|
			t.string :open
			t.string :backlog
			t.string :wip
			t.string :testing
			t.string :done
			t.string :flagged
			t.integer :cycle_time
			t.integer :lead_time
			t.references :setting, foreign_key: true
			t.timestamps
		end
	end
end
