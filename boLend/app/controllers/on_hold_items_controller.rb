class OnHoldItemsController < ApplicationController
	before_action :find_user_set_item_id, only: [:create, :destroy]

	def create
		@on_hold_item = @user.on_hold_items.create(on_hold_item_params)
   		back_to_prev_path
	end
	def destroy
   		@on_hold_item = @user.on_hold_items.find(@item_id)
    	@on_hold_item.destroy
    	back_to_prev_path
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
 		 #puts params.inspect
 		 params.permit(:id,:item_id,:user_id)
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
end
