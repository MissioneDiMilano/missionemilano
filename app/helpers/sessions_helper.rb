module SessionsHelper
    
    #Logs in the given user
    def log_in(user)
       session[:user_id] = user.id
       
       # Also set area
       
       session[:area] = user.get_area
       
       
    end
    
    def current_user
    	@current_user ||= Person.find_by(id: session[:user_id])
    end
    
    def user_area
    	@user_area ||= current_user().get_area	
    end
    
    def logged_in?
    	!current_user.nil?	
    end
    
    def log_out
    	session.delete(:user_id)
    	@current_user = nil
    end
    

    
end
