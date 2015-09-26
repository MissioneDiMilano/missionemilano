class RemoveOrderNumberFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :order_number, :integer
    remove_column :orders, :quantity, :integer
    remove_column :orders, :language, :string
    remove_column :orders, :item, :string
    
    # All of these will now be stored in a JSON/hash string instead.
    add_column :orders, :orderJSON, :string
    add_column :orders, :fulfilledJSON, :string
    
  end
end
