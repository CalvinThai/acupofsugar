class ApplicationController < ActionController::Base
before_action :require_login
  def current_user
  	#change after adding session
  	User.find_by(id: session[:user_id])
    #User.find(2)
  end
    helper_method :current_user
    
  private
    def require_login
      unless current_user
        redirect_to login_url
      end
    end
end
