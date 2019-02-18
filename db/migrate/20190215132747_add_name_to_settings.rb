class AddNameToSettings < ActiveRecord::Migration[5.1]
	def change
		add_column :settings, :name, :string
	end
end
