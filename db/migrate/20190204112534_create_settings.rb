class CreateSettings < ActiveRecord::Migration[5.1]
	def change
		create_table :settings do |t|
			t.string :site
			t.string :base_path
			t.string :context
			t.boolean :debug
			t.string :signature_method
			t.string :key_file
			t.string :consumer_key
			t.boolean :oauth
			t.timestamps
		end
	end
end
