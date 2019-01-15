class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :answers, :type, :field_type
  end
end
