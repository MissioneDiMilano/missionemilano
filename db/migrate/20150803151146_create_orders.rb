class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_number
      t.integer :companionship_number
      t.integer :quantity
      t.string :language
      t.integer :ordering_missionary_number
      t.timestamp :time_stamp

      t.timestamps null: false
    end
  end
end
