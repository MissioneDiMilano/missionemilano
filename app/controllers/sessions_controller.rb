class SessionsController < ApplicationController
  def new
  	if logged_in?
  		redirect_to "/missionary/"
  	end
  	
  end
  
  def create
      user = Person.find_by(user_name: params[:session][:user_name].downcase)
      if user && user.authenticate(params[:session][:password])
          # Log the user in and redirect to the /missionary page. 
          log_in user
          redirect_to "/missionary/"
      else
          # Create an error message.message
          flash.now[:danger] = "Invalid email/password combination"
          render 'new'
      end
  end
  
  def destroy
      log_out
      redirect_to root_url
  end
  
end
