class AddLanguagesQuantitiesLimitsToItems < ActiveRecord::Migration
  def change
  	# These are commented out, because it's already like this somehow when migrating a newly created db...
  #remove_column :items, :languages, :string
	#remove_column :items, :quantities, :string
	#remove_column :items, :limits, :string
	
	add_column :items, :languages, :string, array: true
	add_column :items, :quantities, :integer, array: true
	add_column :items, :limits, :integer, array: true
  end
end
