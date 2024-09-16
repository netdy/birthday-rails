class AddFk < ActiveRecord::Migration[7.2]
  def change
    add_column :people, :user_id, :integer
    add_foreign_key :people, :users, column: :user_id
  end
end
