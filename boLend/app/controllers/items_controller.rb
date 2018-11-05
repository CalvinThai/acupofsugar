class ItemsController < ApplicationController
	def index
		@user = User.find(params[:user_id])
		@borrowed_items = BorrowedItem.joins(:item).select("items.user_id as i_uid, items.*, borrowed_items.*").where('borrowed_items.user_id = ?', params[:user_id])
		@wish_items = WishList.joins(:item).select("items.user_id as i_uid, items.*, wish_lists.*").where('wish_lists.user_id = ?', params[:user_id]) #all items that have been wishlisted by this user
		#the above is same as:
		#@wish_items = Item.joins(:wish_lists).select("items.*").where(...)
		@on_hold_items = OnHoldItem.joins(:item).select("items.*, on_hold_items.*").where('on_hold_items.user_id = ?', params[:user_id])
		@approve_items = OnHoldItem.joins(:item, :user).select("items.*, on_hold_items.*, user.email").where("items.user_id = ? AND on_hold_items.approved = ?", params[:user_id], 'pending')
	end
end
