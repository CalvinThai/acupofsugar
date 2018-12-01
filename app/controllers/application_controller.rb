class ApplicationController < ActionController::Base
before_action :require_login
helper_method :current_user
  def current_user
  	#change after adding session
  	User.find_by(id: session[:user_id])
    #User.find(2)
  end
  def current_user2
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def user_signed_in?
    # converts current_user to a boolean by negating the negation
    !!current_user2
  end

    
  private
    def require_login
      unless current_user
        redirect_to login_url
      end
    end
end
