class OnHoldItemsController < ApplicationController
	def create
	end
	def update
	end
	def destroy
		@user = User.find(params[:user_id])
   		@on_hold_item = @user.on_hold_items.find(params[:id])
    	@on_hold_item.destroy
    	redirect_to user_items_path(@user)
	end
end
