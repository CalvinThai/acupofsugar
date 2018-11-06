class ItemsController < ApplicationController
	def new
		@user = User.find(params[:user_id])
		@item = Item.new
	end

	def create
		    @user = User.find(params[:user_id])
		    @item = @user.items.create(item_params)
			#	@item.status = "available"
		    redirect_to user_items_path(@user)#user_item_path(@user,@item)

		#@item = Item.new()
		#@item.name = params[:name]
		#@item.descr = params[:descr]
		#@item.user_id = params[:user_id]
		#@item.status = "available"

		#if @item.save
		#		redirect_to user_items_path(), notice("Item successfully added!")
		#else
		#		render :new
		#end
	end

	def index

   	@items = Item.item_search(params[:name])
		@user_items = Item.where("items.user_id = ?",params[:user_id])
		#@item = Item.find(1)
	  @borrowed_items = BorrowedItem.joins(:item).select("items.user_id as i_uid, items.*, borrowed_items.*").where('borrowed_items.user_id = ?', params[:user_id])
		@wish_items = WishList.joins(:item).select("items.user_id as i_uid, items.*, wish_lists.*").where('wish_lists.user_id = ?', params[:user_id]) #all items that have been wishlisted by this user
		#the above is same as:
		#@wish_items = Item.joins(:wish_lists).select("items.*").where(...)
		@on_hold_items = OnHoldItem.joins(:item).select("items.*, on_hold_items.*").where('on_hold_items.user_id = ?', params[:user_id])
		@approve_items = OnHoldItem.joins(:item, :user).select("items.*, on_hold_items.*, users.email").where("items.user_id = ? AND on_hold_items.approved = ?", params[:user_id], 'pending')
	end

	def show
		@user = User.find(params[:user_id])
		@item = Item.find(params[:id])
	end

	private
 	 def item_params
 		 params.require(:item).permit(:name, :descr, :status)
 	 end


end
