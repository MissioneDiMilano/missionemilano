class AddItemToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :item, :integer
  end
end
