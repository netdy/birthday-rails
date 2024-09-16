class AddEmailToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :email, :string
    add_column :people, :email, :string
    rename_column :users, :userman, :username
  end
end
