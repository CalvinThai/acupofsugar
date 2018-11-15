class ApplicationController < ActionController::Base

  def current_user
  	#change after adding session
  	User.find_by(id: session[:user_id])
    #User.find(2)
  end
    helper_method :current_user
end
