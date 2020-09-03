class AddTokenizedToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :tokenized, :boolean
  end
end
