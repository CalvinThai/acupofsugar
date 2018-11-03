class WishListsController < ApplicationController
	def create
	end
	def update
	end
	def destroy
		@user = User.find(params[:user_id])
   		@wish_item = @user.wish_lists.find(params[:id])
    	@wish_item.destroy
    	redirect_to user_items_path(@user)
	end
end
