class BorrowedItemsController < ApplicationController

  def new
      @user = User.find(params[:user_id])
      @on_hold_item = OnHoldItem.find(params[:on_hold_item_id])
      @borrowed_item = BorrowedItem.new
  end
  def create
    @user =  User.find(params[:user_id])
    @borrowed_item = @user.borrowed_items.create(borrowed_item_params)
    if @borrowed_item.save
      flash[:success] = "Item successfully added!"
      @curr_user = User.find_by_item_id(@borrowed_item.item_id)
      redirect_to user_items_path(@curr_user)
    else
      flash[:alert] = "Information did not meet requirements"
      render :new
    end
  end
  def destroy
      @borrowed_item = @user.borrowed_items.find_by_item_id(@item_id)
      @borrowed_item.destroy
  end

  private
   def borrowed_item_params
     params.require(:borrowed_item).permit(:id,:item_id,:user_id, :due_on)
   end
end
