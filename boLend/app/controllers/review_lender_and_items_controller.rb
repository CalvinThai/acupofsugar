class ReviewLenderAndItemsController < ApplicationController
#before_action :set_user_item_ids, only: [:new, :create, :destroy]
def index

end
def new
	@user = User.find(params[:user_id])
    @item = Item.find(params[:item_id])
    @review_lender = ReviewLenderAndItem.new
end

def create
	@user = User.find(params[:review_lender_and_item][:user_id])
    @item = Item.find(params[:review_lender_and_item][:item_id])
    @review_lender = @user.review_lender_and_items.create(review_params)
    if @review_lender.save
      flash[:success] = "Thank you for reviewing!"
      @item.returned

      #clear on_hold_item entry & update return date
      @user.on_hold_items.find_by_item_id(@item.id).destroy
      @user.borrowed_items.find_by_item_id(@item.id).set_returned_date
      
      redirect_to user_items_path(@user)
    else
      flash[:alert] = "Information did not meet requirements"
      render :new
    end
end

def destroy

end

def show
	@user = User.find(params[:user_id])
	@item = Item.find(params[:id])
    @review_lender = @user.review_lender_and_items.find_by_item_id(params[:id])
end

private
def review_params
	params.require(:review_lender_and_item).permit(:user_id, :item_id, :lender_id, :rating, :comment);
end
def set_user_item_ids
	@user = User.find(params[:user_id])
    @item = Item.find(params[:item_id])
end
end
