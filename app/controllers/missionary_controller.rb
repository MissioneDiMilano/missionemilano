class MissionaryController < ApplicationController

  before_action :require_login

  def index
  	
  end
  
  def orders
      
      @urls = ["http://store.lds.org/images/estore/categories/000/109_bom_000_c_150.gif","http://store.lds.org/images/estore/categories/000/110_bible_000_c_150.gif"]
      @names = ["Book of Mormon","Bible"]
      
      all_items = Items.all
      
      @names = []
      @unit_sizes = []
      @categories = []
      @languageses = []
      @quantitieses = []
      @limitses = []
      
      
      all_items.each_with_index do |item, index|
      	@names.append(item.name)
      	@unit_sizes.append(item.unit_size)
      	@categories.append(item.category)
      	@languageses.append(item.languages)
      	@quantitieses.append(item.quantities)
      	@limitses.append(limitses.limits)
      end
      
      
      
  end

  def orders_new
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
  
  def return_item_thumbnail(picture_url, title, element_class)
      string_builder = ""
      string_builder = string_builder + '<div class="col-xs-4 col-md-2">'
      string_builder = string_builder + '<div class="thumbnail select-component '+element_class+'">'
      string_builder = string_builder + '<img src="'+picture_url+'">'
      string_builder = string_builder + '<div class="caption"><h5>'+title+'</h5></div>'
      string_builder = string_builder + '</div>' # End thumbnail
      string_builder = string_builder + '</div>' # End cols
      return string_builder
  end
  
  helper_method :return_item_thumbnail
  
  private
  def require_login
	  
	  unless logged_in? && current_user.person_type > 4 
		  redirect_to login_path
	  end
	  
	  
  end
  
end
