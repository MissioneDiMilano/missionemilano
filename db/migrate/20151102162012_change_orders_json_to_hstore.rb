class ChangeOrdersJsonToHstore < ActiveRecord::Migration
  def up
    remove_column :orders, :orderJSON, :string
    remove_column :orders, :fulfilledJSON, :string
	add_column :orders, :orderJSON, :hstore
	add_column :orders, :fulfilledJSON, :hstore
  end
end
