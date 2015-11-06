class AddHstore < ActiveRecord::Migration
  # Ya, bad practice to go back and nullify all of these operations, but atleast I'm leavinga trail.
  # I just don't want my c9.io HDD to blow up on me if I try to apt-get the necessary stuff this time around, and since I don't need it anymore
  # it's not worth the risk.
  def up
	#enable_extension "hstore"
  end

  def down
	#disable_extension "hstore"
  end
end
