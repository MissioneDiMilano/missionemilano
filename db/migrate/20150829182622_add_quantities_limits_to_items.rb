class AddQuantitiesLimitsToItems < ActiveRecord::Migration
  def change
    add_column :items, :quantities, :string
    add_column :items, :limits, :string
  end
end
