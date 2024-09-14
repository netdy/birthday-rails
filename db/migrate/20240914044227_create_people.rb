class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people do |t|
      t.string :nickname
      t.date :birthdate
      t.text :note

      t.timestamps
    end
  end
end
