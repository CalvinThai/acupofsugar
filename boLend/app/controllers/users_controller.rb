class UsersController < ApplicationController
	def index
    @users = User.user_search(params[:name])
		@user = User.find(session[:user_id]) #for testing
	end
  def indexx
    @users = User.all
  end
	def show
		@user = User.find(params[:id])
	end
  def new
  end
  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = 'Welcome to BoLend! Your account has been verified.'
      redirect_to root_url
    else 
      flash[:error] = 'Error: user does not exist.'
      redirect_to root_url
    end
  end


  def create
    @user = User.new(user_params)
    if @user.save
      #UserMailer.registration_confirmation(@user).deliver
      UserMailer.with(user: @user).welcome_email.deliver_later
      flash[:registration_msg] = "Registration successful! Please verify your email address."
      redirect_to users_new_url

    else
      flash[:registration_msg] = "Registration Failure"
      redirect_to users_new_url
    end
  end

  private def user_params
    params.require(:user).permit(:email, :password, :fname, :lname)
  end

end
