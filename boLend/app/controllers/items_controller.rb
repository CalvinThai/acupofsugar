class ItemsController < ApplicationController
	def new
		@user = User.find(params[:user_id])
		@item = Item.new
	end

	def create
		    @user = User.find(params[:user_id])
		    @item = @user.items.create(item_params)
			#	@item.status = "available"
				if @item.save
					flash[:success] = "Item successfully added!"
					redirect_to user_items_path(@user)
				else
					flash[:alert] = "Information did not meet requirements"
					render :new
				end
		    #redirect_to user_items_path(@user)#user_item_path(@user,@item)

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
#	search = params[:search].presence || "*"

	  #  @items = Item.search search, aggs: [:status]


	def index
		@user = User.find(params[:user_id])
		#find user if view is for /users/:id/items
		auth_and_redirect
		if(params[:user_id])
			@user = User.find(params[:user_id])
			get_manageable_items
		end
		#testing only, empty session
		#session[:user_id] = nil;
		@filterrific = initialize_filterrific(
			Item,
			params[:filterrific],
			select_options: {
      sorted_by: Item.options_for_sorted_by,
			with_category: Item.options_for_category

    }

		) or return
		@items = @filterrific.find.page(params[:page])

		respond_to do |format|
			format.html
			format.js
		end

   	#@items = Item.item_search(params)
		@aggs = Item.search "*", aggs: [:status]
		@category_aggs = Item.search "*", aggs: [:category]
		@status_filter = Item.status_filter(params[:status])
		@category_filter = Item.category_filter(params[:category])

	end

	def show #can be invoked from many URI; use the item_path if applicable
		#auth_and_redirect
		@user;
		if(session[:user_id])
		  	@user = User.find(session[:user_id])
		end
		#find user if not passed by params, required for user-specific actions
		@item = Item.find(params[:id])
		@owner_id = @item.user_id

		#for review section
		@reviews = ReviewLenderAndItem.joins(:user).select("review_lender_and_items.*, users.*").where("review_lender_and_items.item_id = ?", @item.id)
		@ratings = @reviews.average(:rating)
	end
	def edit
		@user = User.find(params[:user_id])
		@item = @user.items.find_by_id(params[:id])
	end
	def update
		@user = User.find(params[:user_id])
		#@item = Item.find(params[:id])
	    @item = @user.items.find_by_id(params[:id])
	    if @item.update(item_params)
	      redirect_to user_items_path(@user.id)
	    else
	      render 'edit'
	    end
	end
	def destroy
		@user = User.find(params[:user_id])
		@item = @user.items.find_by_id(params[:id])
    	@item.destroy
    	redirect_to user_items_path(@user.id)
	end
	private
 	 def item_params
 		 params.require(:item).permit(:name, :descr, :status, :category, :latitude, :longitude, :address, :country, :street, :city, images: [])
	 end
 	 #get all items of interest by this user
 	 def get_manageable_items
 	 	@user_items = Item.where("items.user_id = ?",params[:user_id])
	 	@borrowed_items = BorrowedItem.joins(:item).select("items.user_id as i_uid, items.*, borrowed_items.*").where('borrowed_items.user_id = ?', params[:user_id])
		@wish_items = WishList.joins(:item).select("items.user_id as i_uid, items.*, wish_lists.*").where('wish_lists.user_id = ?', params[:user_id]) #all items that have been wishlisted by this user
		@on_hold_items = OnHoldItem.joins(:item).select("items.*, on_hold_items.*").where('on_hold_items.user_id = ?', params[:user_id])
		@lend_items = OnHoldItem.joins(:item, :user).select("items.*, on_hold_items.*, users.email").where("items.user_id = ?", params[:user_id])
		@pending_items = @lend_items.where(approved: 'pending')
		@approved_items = @lend_items.where(approved: 'Approved')
		extension= BorrowedItem.joins(:item).select("items.*,borrowed_items.*").where('items.user_id = ?', params[:user_id])
	 	@ext_pending = extension.where(approved: 'pending')

		@transaction_items = ItemTransaction.joins(:item, :user).select("item_transactions.*").where('item_transactions.user_id = ?', params[:user_id])
		@trans_lent = @transaction_items.where(user_status: 'Lender')
		@trans_borrow = @transaction_items.where(user_status: 'Borrower')
	 end

	 def auth_and_redirect
	 	#puts("@@@@@@@@@@@@@@@@in auth_redirect")
	 	#puts("@@@@@@@@@@@@@@@@ session[:user_id] = #{session[:user_id]}")
	 	#puts("@@@@@@@@@@@@@@@@ params[:user_id] = #{params[:user_id]}")

	 	#if no session exist, prompt user to sign in
	 	if(session[:user_id] == nil || session[:user_id].to_i != params[:user_id].to_i)
	 		puts(session[:user_id] == nil)
	 		puts(session[:user_id].to_i != params[:user_id].to_i)
		 	if(params[:auth] && params[:auth] == "login_required")
				session[:auth] = params[:auth]
				#clear session
				session[:user_id] = nil
				url = request.fullpath if request.get?
				uri = URI.parse(url)
				query = Rack::Utils.parse_query(uri.query)
				# Replace auth to true upon login
				query["auth"] = true
				uri.query = Rack::Utils.build_query(query)
				return_addr = uri.to_s
				#come back to current page after successful login
				session[:return_to] ||= return_addr
				redirect_to login_path
			end
		end
	 end
end

def address
[street, city, country].compact.join(', ')
end
