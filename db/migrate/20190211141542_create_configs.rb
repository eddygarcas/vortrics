class CreateConfigs < ActiveRecord::Migration[5.1]
	def change
		create_table :configs do |t|
			t.integer :user_id
			t.integer :setting_id

			t.timestamps
		end
	end
end
