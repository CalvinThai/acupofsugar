class ItemsController < ApplicationController
	def index
		@user = User.find(params[:user_id])
		@borrowed_items = @user.items.where('status = ?', "borrowed")
	end
end
