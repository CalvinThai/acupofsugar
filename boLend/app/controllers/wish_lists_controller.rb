class WishListsController < ApplicationController
	before_action :find_user_set_item_id, only: [:create, :destroy]
	#after_action :back_to_prev_path, only: [:create, :destroy]

	def create
   		@wish_item = @user.wish_lists.create(wish_item_params)
   		if @wish_item.save
        item = Item.find(@wish_item.item_id).name
        flash[:success_msg] = "Item [#{item}] has been added to your wish list!"
      else
        flash[:failure_msg] = "Something went wrong!"
      end
      set_locals_render_partial
	end
	def update
	end
	def destroy
   		@wish_item = @user.wish_lists.find_by_item_id(@item_id)
      item = Item.find(@wish_item.item_id).name
    	@wish_item.destroy
    	#back_to_prev_path
      if(!@wish_item)
        flash[:success_msg] = "Item [#{item}] has been deleted from your wish list!"
      end
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

   def set_locals_render_partial
    puts params.inspect
    if(params[:from] && params[:from] == "itemIndex")
      @user = User.find(params[:user_id])
      @item = Item.find(params[:item_id])
      @owner_id = @item.user_id
      render(:partial => "items/user_actions_for_item" , :locals => {user: @user, item: @item, owner_id: @owner_id})
    else
     redirect_to user_items_path(params[:user_id])
    end
  end 
end
