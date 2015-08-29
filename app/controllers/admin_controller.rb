class AdminController < ApplicationController
  def users # For User admin
    @users = Person.where("people.person_type > 3") # Get all missionary users.
    
    if request.post? && params.include?(:names) && params.include?(:user_names) && params.include?(:types) && params.include?(:areas) # If it's a post method, we should be updating.
    	json_text = Rails.application.assets.find_asset("user_types.json").source
    	@person_types = ActiveSupport::JSON.decode(json_text)["user_types"]

		current_areas = Area.all
    	all_people = Person.all
    	
    	new_names = params[:names].split("|")
    	new_names_original = params[:names].split("|")
    	new_user_names = params[:user_names].split("|")
    	new_person_types = params[:types].split("|")
    	new_areas = params[:areas].split("|")
    	new_zones = params[:zones].split("|")
    	new_areas_unique = new_areas.uniq
    	new_areas_comp_count = [0]*new_areas_unique.length 
    	
    	# First, check for old people to delete.
    	#render :text => person_types.to_s
    	
    	
    	
    	
    	# Prep - delete all the old people, and make everyone inactive
    	all_people.each do |person|
    		#
    		if (person.person_type > 3) && (person.created_at < 3.years.ago) && (person.updated_at < 1.year.ago)
				Person.destroy(person)
			elsif person.person_type > 3
				# Set everyone to be inactive - we'll set the active people to their new positions next
				person.person_type = person_types["inactive"]["user_type_number"]
				person.save
    		end
    	end
    	
    	#Prep - empty all areas.
    	current_areas.each do |area_record|
    		area_record.person_one = nil
    		area_record.person_two = nil
    		area_record.person_three = nil
    		
    	end
    	
    	
    	# Update
		
    	new_names.each_with_index do |name, index|
    		person = all_people.where('name = ?', name)
    		if person.length == 0
    			# It person doesn't exist, create it.
    			
    			person = Person.create(person_type: person_types[new_person_types[index]]["user_type_number"], name: name, user_name: new_user_names[index], password: "nephi27")
    			person.save
    			
    			
    			
    		else 
    			# It exists, update it.
    			#
    			person = person[0]
    			person.person_type = new_person_types[index]
    			person.save
    		end
    		
    		# Update this person's area.
    		#
			his_area = new_areas[index]
			his_zone = new_zones[index]
			his_areas_index = new_areas_unique.index(his_area)
			areas_current_comp_count = new_areas_comp_count[his_areas_index]
			
			if current_areas.any? {|a| a.name == his_area}
				# It already exists, find it and modify it.
				area_record = current_areas.where(name: his_area)[0]
				area_record.person_one = person.name
				if (areas_current_comp_count == 0) # First time seeing this area, reset it.
					area_record.person_two = nil
					area_record.person_three = nil
				end
				area_record.save
				new_areas_comp_count[his_areas_index] += 1
			else 
				#
				#It doesn't exist, create it.
				new_area = Area.create(name: his_area, zone: his_zone)
				new_area.save
				current_areas = Area.all
			end
    		
    	end
    	
    	# Done? Everyone's updated?
    	
    	
    end
    
    
    
  end

  def special_questions
  end

  def special_questions_area
  end

  def special_questions_area
  end

  def special_questions_admin
  end

  def orders
  end

  def orders_fill
  end

  def orders_fill_view
  end

  def orders_inventory
  end

  def orders_inventory_view
  end

  def parental_contact
  end

  def recommendations
  end

  def baptismal_submission
  end
end
