class AddPostitToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :postit, null: true, foreign_key: true
  end
end
