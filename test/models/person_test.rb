require 'test_helper'

class PersonTest < ActiveSupport::TestCase
    
    def setup
        @user = Person.new(user_name: "Christensen, Kenneth Alan")
    end
    
    test "name should be present" do
        @user.name = "      "
        assert_not @user.valid?
    end
    
    test "user_name should be present" do 
        @user.name_name = "      "
        assert_not @user.valid?
    end
    
end
