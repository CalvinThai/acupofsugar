class OnHoldItemsController < ApplicationController
	before_action :find_user_set_item_id, only: [:create, :destroy]
	def new
		@user = User.find(params[:user_id])
		@item = Item.find(params[:item_id])
		@on_hold_item = OnHoldItem.new
		respond_to do |format|
	      format.js  {}
	    end
	end
	def create
		@on_hold_item = @user.on_hold_items.create(on_hold_item_params)
   		#back_to_prev_path
   		#defining locals 
   		set_locals_render_partial
	end
	def destroy
   		@on_hold_item = @user.on_hold_items.find_by_item_id(@item_id)
    	@on_hold_item.destroy
    	#back_to_prev_path
    	#render(:partial => "items/user_actions_for_item" , :locals => {:user => params[:], @item})
    	set_locals_render_partial
	end

	def update_request_status
		@on_hold_item = OnHoldItem.find(params[:on_hold_item_id])
		if params[:result] == "approved"
			@on_hold_item.approve_req
			@on_hold_item.save
		elsif params[:result] == "denied"
			@on_hold_item.reject_req
			@on_hold_item.save
		end
		#need to add message success/fail and refresh page
	end

	private
	 def on_hold_item_params
 		 params.require(:on_hold_item).permit(:id,:item_id,:user_id, :req_on, :due_date)
 	 end
 	 def find_user_set_item_id
 	 	@user = User.find(params[:user_id])
		@item_id = params[:id]
		if(!@item_id)
			@item_id = params[:item_id]
		end
 	 end

 	 def back_to_prev_path
 	 	if(params[:from] && params[:from] == 'itemIndex')
    		redirect_to item_path(@item_id)
    	else
    		redirect_to user_items_path(@user)
    	end
 	 end
 	def set_locals_render_partial
 		puts params.inspect
 		if(params[:from] && params[:from] == "itemIndex")
 			#render 'items#show'
 			#puts params.inspect
	 		@user = User.find(params[:user_id])
	   		@item = Item.find(params[:item_id])
	   		@owner_id = @item.user_id
	   		render(:partial => "items/user_actions_for_item" , :locals => {user: @user, item: @item, owner_id: @owner_id})
		else
			redirect_to user_items_path(params[:user_id])
		end
	end	
end
