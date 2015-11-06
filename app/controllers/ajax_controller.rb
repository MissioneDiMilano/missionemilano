class AjaxController < ApplicationController
  def orders
    op = nil
  	response_hash = nil
  	if params.include?(:op)
  		op = params[:op]
  	end
  	
    case op
    when "Receive order"
      if params.include?(:itemJSON)
        #byebug
        orderJSON = params[:itemJSON].to_unsafe_h
        fulfilledJSON = params[:itemJSON].to_unsafe_h.clone
        fulfilledJSON.keys().each do |i|
          fulfilledJSON[i].keys().each do |j|
            fulfilledJSON[i][j] = 0
          end
        end
        area = user_area()
        user = current_user().id
        
        orderJSON = Order.serialize_order(orderJSON)
        fulfilledJSON = Order.serialize_order(fulfilledJSON)
        
        order = Order.create(:companionship_number => area, :ordering_missionary_number => user, :fulfilled => 0, :orderJSON => orderJSON, :fulfilledJSON => fulfilledJSON)
        @success = true;
        
      end
    when "Delete order"
      if params.include?(:id)
        Order.destroy(params[:id])
      end
    end
  end

  def special_questions
  end

  def inventory
  end

  def parent_contacts
  end

  def baptismal_submissions
  end
end
