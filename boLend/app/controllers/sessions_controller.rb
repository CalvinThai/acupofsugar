class SessionsController < ApplicationController
skip_before_action :require_login
  def new
    # a logged in user should not see login page again until they log out
    if current_user
      redirect_to user_path(current_user)
    end	
  end
  
  def create
    @user = current_user
    if request.env['omniauth.auth']
      user = User.create_with_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id    
      redirect_to user_path(user.id)
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password_digest])
        if user.email_confirmed
          #flash[:failure] = "suceess"
          session[:user_id] = user.id
          redirect_to user #should login to the user page
          # Log the user in and redirect to the user's show page.
          
          #redirect_to profile_path #save for later use, redirect user to /profile page rather than /user/:id - by jiehao
        else 
          flash[:verification] =  'Please verify your email address first.'
          redirect_to login_url
        end
      else
       flash[:failure] = "The email address or password you entered is incorrect. "
        redirect_to login_url
      end
  end
end
=begin

  def create
    user = User.find_by(email: params[:session][:email].downcase)
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
=end


  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
end