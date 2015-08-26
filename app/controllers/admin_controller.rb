class AdminController < ApplicationController
  def users # For User admin
    @users = Person.where("people.person_type > 3") # Get all missionary users.
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
