class MissionaryController < ApplicationController

  before_action :require_login

  def index
  	
  end
  
  def orders
      

  end

  def orders_new
  	
  	  @urls = ["http://store.lds.org/images/estore/categories/000/109_bom_000_c_150.gif","http://store.lds.org/images/estore/categories/000/110_bible_000_c_150.gif"]
	  @names = ["Book of Mormon","Bible"]
	  
	  
	  all_items = Item.all
	  
	  @items = all_items
	  @names = []
	  @unit_sizes = []
	  @categories = []
	  @languageses = []
	  @quantitieses = []
	  @limitses = []
	  
	  @unique_categories = []
	  
	  @area_orders = []
	  
	  all_items.each_with_index do |item, index|
		  @names.append(item.name)
		  @unit_sizes.append(item.unit_size)
		  @categories.append(item.category)
		  @languageses.append(item.languages)
		  @quantitieses.append(item.quantities)
		  @limitses.append(item.limits)
		  
		  unless @unique_categories.include?(item.category)
		  	@unique_categories.append(item.category)
		  end		  
	  end
  	
  	  
  	  # Delete all fulfilled orders older than 6 months.
  	  # Delete all un-fulfilled orders older than 9 months.
  	  
  	  oldOrders = Order.where("created_at < ?",6.months.ago)
  	  oldOrders.each do |ord|
  	  	if ord.quantity >= ord.fulfilled || ord.created_at < 9.months.ago
  	  		ord.destroy()	
  	  	end
  	  end
  	  
  	  @area_orders = Order.where(companionship_number: current_user().id)
  	  
  	
  	
  end

  def special_questions
  end

  def special_questions_history
  end

  def recommendations
  end

  def baptismal_submission
  end

  def parent_contact
  end
  
  

  
  private
  def require_login
	  
	  unless logged_in? && current_user.person_type > 4 
		  redirect_to login_path
	  end
	  
	  
  end
  
end
