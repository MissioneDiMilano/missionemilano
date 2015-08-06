class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :type
      t.string :name
      t.string :user_name
      t.string :password_hash
      t.date :release_date

      t.timestamps null: false
    end
  end
end
