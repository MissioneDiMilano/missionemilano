class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :zone
      t.integer :person_one
      t.integer :person_two
      t.integer :person_three

      t.timestamps null: false
    end
  end
end
