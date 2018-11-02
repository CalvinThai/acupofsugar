class UsersController < ApplicationController
	def index
    @users = User.search(params[:name])
		@user = User.find(1) #for testing
	end
	def show
		@user = User.find(params[:id])
	end


end
