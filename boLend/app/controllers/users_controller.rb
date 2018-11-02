class UsersController < ApplicationController
	def index
		#@users = User.all
		@user = User.find(1) #for testing
	end
	def show
		@user = User.find(params[:id])
	end


end
