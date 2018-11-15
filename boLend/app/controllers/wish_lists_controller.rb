class WishListsController < ApplicationController
	before_action :find_user_set_item_id, only: [:create, :destroy]
	#after_action :back_to_prev_path, only: [:create, :destroy]

	def create
   		@wish_item = @user.wish_lists.create(wish_item_params)
   		#back_to_prev_path
   		#respond_to do |format|
        	#format.js { 
    		#	render :template => "items/user_action_ajax.js.erb", 
           	#	:layout => false  
 			#}
 			#format.js { render :action => 'items/user_action_ajax.js.erb'}
 			#format.js
    	#end
      set_locals_render_partial
	end
	def update
	end
	def destroy
      puts params.inspect
   		@wish_item = @user.wish_lists.find_by_item_id(@item_id)
    	@wish_item.destroy
    	#back_to_prev_path
      set_locals_render_partial
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
   def set_locals_render_partial
    puts params.inspect
    if(params[:from] && params[:from] == "itemIndex")
      #render 'items#show'
      #puts params.inspect
      @user = User.find(params[:user_id])
      @item = Item.find(params[:item_id])
      @owner_id = @item.user_id
        #ItemsController.show
      render(:partial => "items/user_actions_for_item" , :locals => {user: @user, item: @item, owner_id: @owner_id})
    else
      #render 'items#index'
     redirect_to user_items_path(params[:user_id])
    end

  end 
end
