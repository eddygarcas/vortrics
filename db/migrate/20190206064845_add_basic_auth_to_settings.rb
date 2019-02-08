class AddBasicAuthToSettings < ActiveRecord::Migration[5.1]
	def change
		add_column :settings, :login, :string
		add_column :settings, :password, :string
	end
end
