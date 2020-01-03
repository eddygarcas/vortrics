class AddDescriptionToPostits < ActiveRecord::Migration[6.0]
  def change
    add_column :postits, :description, :string
  end
end
