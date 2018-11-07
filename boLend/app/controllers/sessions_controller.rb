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
      if user.email_confirmed
        flash[:failure] = "suceess"
        session[:user_id] = user.id
        redirect_to user #should login to the user page
        # Log the user in and redirect to the user's show page.
        
        #redirect_to profile_path #save for later use, redirect user to /profile page rather than /user/:id - by jiehao
      else 
        flash[:failure] =  'Please verify your email address.'
        redirect_to login_url
      end
    else
      flash[:failure] = "rekt"
      redirect_to login_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
end