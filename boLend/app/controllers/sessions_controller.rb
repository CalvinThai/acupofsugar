class SessionsController < ApplicationController

  def new
  	
  end

  def create
    #user = User.find_by_email(params[:email])
    #user = User.find_by_email(email: params[:session][:email].downcase)
    user = User.find_by(email: params[:session][:email].downcase)
   # if user && user.authenticate(params[:password])
   #if user && user.authenticate(params[:password_digest])
   if user && user.authenticate(params[:session][:password_digest])
      flash[:notice] = "suceess"
      session[:user_id] = user.id
      redirect_to login_url
      # Log the user in and redirect to the user's show page.
    else
      flash[:notice] = "rekt"
      redirect_to login_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
end