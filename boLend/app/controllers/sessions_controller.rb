class SessionsController < ApplicationController
skip_before_action :require_login
  def new
    @user = current_user
  	
  end
  def create
    @user = current_user
  if (session[:user_id] != nil)
    flash[:failure] = "Already logged in"
    redirect_to login_url
  else
    if request.env['omniauth.auth']
      user = User.create_with_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id    
      redirect_to user_path(user.id)
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password_digest])
        if user.email_confirmed
          flash[:failure] = "suceess"
          session[:user_id] = user.id
          if (!session[:auth])
            redirect_to user #should login to the user page
          else 
            session[:auth] = nil
            params[:auth] = nil
            redirect_to session.delete(:return_to)
          end
          # Log the user in and redirect to the user's show page.
          
          #redirect_to profile_path #save for later use, redirect user to /profile page rather than /user/:id - by jiehao
        else 
          flash[:failure] =  'Please verify your email address.'
          redirect_to login_url
        end
      else
       flash[:failure] = "The emaill address or password you entered is incorrect. "
        redirect_to login_url
      end
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
    flash[:failure] = "successfully logged out"
    session[:user_id] = nil
    redirect_to login_url
  end
end