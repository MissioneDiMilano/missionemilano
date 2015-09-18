class AddFulfilledToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fulfilled, :integer
  end
end
