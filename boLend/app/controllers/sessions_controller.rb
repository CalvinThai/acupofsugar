class SessionsController < ApplicationController

  def new
  	
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password_digest])
      sessions[:uuser_id] = user.id
      redirect_to admin_url
      # Log the user in and redirect to the user's show page.
    else
      redirect_to login_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
end