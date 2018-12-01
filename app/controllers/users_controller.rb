class UsersController < ApplicationController
skip_before_action :require_login, except: [:index, :indexx, :show, :edit, :update]
	def index
    @users = User.user_search(params[:name])
    if session[:user_id].nil?
      redirect_to login_path
    else
		  @user = User.find(session[:user_id]) #for testing
      #@user = User.find(1)
      @blockee_users = Blockee.blockees_of_user(@user)
      @time = greetings_by_time
    end
	end
  def indexx
    @user = current_user
    @users = User.all
  end
	def show
		@user = User.find(params[:id])
    @logged_in_user = User.find(session[:user_id])
    @notification = Notification.find_by_user_id(@user.id)
    @blockee_users = Blockee.blockees_of_user(@user)
	end
  def new
    @user = User.new
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
      UserMailer.registration_confirmation(@user).deliver_now
      #UserMailer.with(user: @user).welcome_email.deliver
      Notification.create(:user_id => @user.id);
      flash[:success_msg] = "Registration successful! Please verify your email address."
      redirect_to login_path

    else
      flash[:failure_msg] = "Registration failed"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @logged_in_user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(user_params)
      flash[:success] = "updated"
      redirect_to @user

    else

    end
  end

  def greetings_by_time
    time = Time.now.hour
    if time>6 and time<12
      "Good Morning"
    elsif time>12 and time<17
      "Good Afternoon"
    else
      "Good Evening"
    end
  end

  private def user_params
    params.require(:user).permit(:email, :password, :fname, :lname, :phonenum, :address)
  end

end