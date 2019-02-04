class AddDataToSettings < ActiveRecord::Migration[5.1]
	def change
		add_column :settings, :key_data, :binary
	end
end
