class WishListsController < ApplicationController
	before_action :find_user_set_item_id, only: [:create, :destroy]
	#after_action :back_to_prev_path, only: [:create, :destroy]

	def create
   		@wish_item = @user.wish_lists.create(wish_item_params)
   		back_to_prev_path
   		#respond_to do |format|
        	#format.js { 
    		#	render :template => "items/user_action_ajax.js.erb", 
           	#	:layout => false  
 			#}
 			#format.js { render :action => 'items/user_action_ajax.js.erb'}
 			#format.js
    	#end
	end
	def update
	end
	def destroy
   		@wish_item = @user.wish_lists.find_by_item_id(@item_id)
    	@wish_item.destroy
    	back_to_prev_path
    	#respond_to do |format|
        	#format.js { 
    		#	render :template => "items/user_action_ajax.js.erb", 
           	#	:layout => false  
 			#}
 			#format.js { render :action => 'items/user_action_ajax.js.erb'}
 			#format.js
    	#end
	end
	private
 	 def wish_item_params
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
