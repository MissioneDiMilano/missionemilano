class RemoveLanguagesQuantitiesLimitsFromItems < ActiveRecord::Migration
  def change
  	remove_column :items, :languages, :string
  	remove_column :items, :quantities, :string
  	remove_column :items, :limits, :string
  end
end
 