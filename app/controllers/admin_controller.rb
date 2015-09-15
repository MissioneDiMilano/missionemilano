class AdminController < ApplicationController
	
	before_action :require_login
	
	
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
    			
    			person = Person.create(person_type: @person_types[new_person_types[index]]["user_type_number"], name: name, user_name: new_user_names[index], password: "nephi27")
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
  	all_items = Item.all
  	
  	@items = []
  	@categories = []
  	@languages = []
  	@ids = []
  	
  	all_items.each do |i|
  		@ids.append(i.id);
  		unless @categories.include?(i.category)
  			@categories.append(i.category)
  		end
  		
  		i.languages ||= []
  		i.languages.each_with_index do |l, index|
			#@items.append({:id => i.id, :name =>  i.name, :unit_size => i.unit_size, :language =>  l, :quantity =>  i.quantities[index], :limit =>  i.limits[index]})
			unless @languages.include?(l)
				@languages.append(l)
			end
			
 		end
  	end
  	@items = all_items
  	
=begin
	# No longer needed. Change strategy to send all orders/inventory ajax requests to orders/inventory/ajax.


  	@post_result = "empty"
  	response_message = "No message."
  	item_created = false
  	if request.post?
  		if params.include?(:id) && params.include?(:category) && params.include?(:name)	&& params.include?(:unit-sizes) && prams.include?(:languages) && params.include?(:quantities) && params.include?(:limits)
  			# Then we're on a post request and we have the necessary things.
  			# Find the item with that id, and update all fields.
  			begin
	 			current_item = Item.find(params[:id])
 				current_item.name = params[:name]
 				current_item.category = params[:category]
 				current_item.unit_sizes = params[:unit_size]
 				current_item.languages = params[:languages]
 				current_item.quantities = params[:quantities]
 				current_item.limits = params[:limits]
 				message = "Item '"+current_item.name+"' saved."
   			rescue ActiveRecord::RecordNotFound
  				current_item = Item.new(:name => params[:name], :category => params[:category], :unit_sizes => params[:unit_size], :languages => params[:languages], :quantities => params[:quantities], :limits => params[:limits])
  				item_created = true
  				message = "Item '"+current_item.name+"' created."
  			end

  			save_return = current_item.save
  			if save_return == true # Saved...
  				@post_result = {:success => true, :new_created => item_created, :missing_param => false, :message => response_message}
  			else 
  				@post_result = {:success => false, :new_created => false, :missing_param => false, :message => "There was an error in saving/creating item."}
  			end
  		else
  		# Then we're on a post request, but we need to return an error.
  		@post_result = {success => false, :new_created => false, :missing_param => true, :message => "Missing parameter. Please use designated API."}
  		end
  	end
  		
  	respond_to do |format|
  		format.html #show the regular file
  		format.json do
  			if @post_result == "empty" # Still
  				redirect_to "/admin/orders_inventory", notice: "Redirecting..."
  			else
  				render :json => @post_result.to_json	
  			end
  		end
  	end
=end

  end

  def orders_inventory_view
  end


  # Will handle all changes to the inventory.
  def orders_inventory_ajax
  	op = nil
  	response_hash = nil
  	if params.include?(:op)
  		op = params[:op]
  	end
  	
  	#byebug
  	case op
  	when "Add/Edit item" 
  		# Add/Edit the item and prepare response_hash
  		# If it is an edit, params[:id] is -1, which will never be found in db, so always created.
  		
  		# Vars for the response_hash
  		response_message = nil
  		item_created = false
  		
  		
  		#byebug
  		# Check required params. If we've got them, create or edit the item.
  		if params.include?(:id) && params.include?(:category) && params.include?(:name)	&& params.include?(:unit_size) && params.include?(:languages) && params.include?(:quantities) && params.include?(:limits)
  			begin # Assume that the id isn't -1, and that it exists.
				 current_item = Item.find(params[:id])
				 current_item.name = params[:name]
				 current_item.category = params[:category]
				 current_item.unit_size = params[:unit_size]
				 current_item.languages = params[:languages]
				 current_item.quantities = params[:quantities]
				 current_item.limits = params[:limits]
				 message = "Item '"+current_item.name+"' saved."
			   rescue ActiveRecord::RecordNotFound  #we hope, if we get this error, that the params[:id] is -1, and not some error.
				  current_item = Item.new(:name => params[:name], :category => params[:category], :unit_size => params[:unit_size], :languages => params[:languages], :quantities => params[:quantities], :limits => params[:limits])
				  item_created = true
				  message = "Item '"+current_item.name+"' created."
			  end
			  
			  # The changes are not yet in the db in either case, save them and check success.
			  save_return = current_item.save
			  saved_item_id = current_item.id
			  
			  # Completed, update the response_hash to be fed sent back to the client.
			  if save_return == true # Saved...
				  response_hash = {:success => true, :new_created => item_created, :missing_param => false, :message => response_message, :item_id => saved_item_id}
			  else 
				  response_hash = {:success => false, :new_created => false, :missing_param => false, :message => "There was an error in saving/creating item.", :item_id => saved_item_id}
			  end
			  
  		else # We are missing info, do nothing, return error.
  				  response_hash = {:success => false, :new_created => false, :missiong_param => true, :message => "Error in request parameters.", :item_id => nil}
  		end
  	else
  		# Error, do nothing.
  	end
  	
  	
  	render :json => response_hash.to_json
  end


  def parental_contact
  end

  def recommendations
  end

  def baptismal_submission
  end
  
  private
  def require_login
  	
  	unless logged_in? && current_user.person_type <= 4 
  		redirect_to login_path
  	end
  	
  	
  end
  
  
  
end
