class ItemsController < ApplicationController
	def index
		@user = User.find(params[:user_id])
		@borrowed_items = @user.items.where('status = ?', "borrowed") #need borrowed_items table
		@wish_items = WishList.joins(:item).select("items.*").where('wish_lists.user_id = ?', params[:user_id]) #all items that have been wishlisted by this user
	end
end
