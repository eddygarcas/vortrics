class ChangeAdviceColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :advices, :type, :advice_type
  end
end
