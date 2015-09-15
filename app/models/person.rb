class Person < ActiveRecord::Base
	
	
    #belongs_to :area
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :user_name, presence: true, length: { maximum: 50 }, uniqueness: {case_sensitive: false }
    validates :person_type, presence: true
    
    has_secure_password
    validates :password, presence: true, length: { minimum: 3 }
    
    
    def get_area
    	myName = self.name
    	all_areas = Area.all
    	all_areas.each do |a|
    		if (myName.eql?(a.person_one) || myName.eql?(a.person_two) || myName.eql?(a.person_three))
    			return a
    		end
    	end
		return nil 
    	
    end
end
