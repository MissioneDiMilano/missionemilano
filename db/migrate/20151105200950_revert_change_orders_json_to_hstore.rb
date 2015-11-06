class RevertChangeOrdersJsonToHstore < ActiveRecord::Migration
  def change
    # See note to 20151030175103 migration.
    #remove_column :orders, :orderJSON, :hstore
    #remove_column :orders, :fulfilledJSON, :hstore
	  #add_column :orders, :orderJSON, :string
	  #add_column :orders, :fulfilledJSON, :string
  end
end
