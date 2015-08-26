class RemovePasswordHashFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :password_hash, :string
  end
end
