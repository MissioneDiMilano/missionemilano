class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :languages
      t.integer :unit_size

      t.timestamps null: false
    end
  end
end
