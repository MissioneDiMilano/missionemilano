class AjaxController < ApplicationController
  def orders
    if params.include?(:itemJSON)
      
      orderJSON = params[:itemJSON]
      fulfilledJSON = orderJSON.clone
      fulfilledJSON.keys().each do |i|
        fulfilledJSON[i].keys().each do |j|
          fulfilledJSON[i][j] = 0
        end
      end
      area = user_area()
      user = current_user().id
      
      order = Order.create(:companionship_number => area, :ordering_missionary_number => user, :fulfilled => 0, :orderJSON => orderJSON, :fulfilledJSON => fulfilledJSON)
      @success = true;
      
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
