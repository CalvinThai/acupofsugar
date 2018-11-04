class UsersController < ApplicationController
	def index
    @users = User.user_search(params[:name])
		@user = User.find(1) #for testing
	end
	def show
		@user = User.find(params[:id])
	end
  def new 
    @user = User.new
  end

  def create
    @user = User.find(1) #should be the current login user
    @friend = User.find(params[:friend])
    @user.friend_request(@friend)
    render 'index'
  end
  
end
