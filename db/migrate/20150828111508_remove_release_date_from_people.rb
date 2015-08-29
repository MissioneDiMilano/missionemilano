class RemoveReleaseDateFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :release_date, :date
  end
end
