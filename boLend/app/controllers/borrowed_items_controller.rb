class BorrowedItemsController < ApplicationController

  def new
      @user = User.find(params[:user_id])
      @on_hold_item = OnHoldItem.find(params[:on_hold_item_id])
      @borrowed_item = BorrowedItem.new
  end

  def edit
    @user = User.find(params[:user_id])
    @item = Item.find(params[:id])
    @borrowed_item = BorrowedItem.find_by_item_id(params[:id])
  end
  def create
    @user =  User.find(params[:user_id])
    @borrowed_item = @user.borrowed_items.create(borrowed_item_params)
    if @borrowed_item.save
      flash[:success] = "Item successfully added!"
      @item = Item.find_by_id(@borrowed_item.item_id)
      @item.lent_out
      @curr_user = User.find_by_id(@item.user_id)
      redirect_to user_items_path(@curr_user)
    else
      flash[:alert] = "Information did not meet requirements"
      render :new
    end
  end

  def update
    @user = User.find(params[:user_id])
    @borrowed_item = BorrowedItem.find(params[:id])
    @item = Item.find(@borrowed_item.item_id)

    if @borrowed_item.update(borrowed_item_params)
      @borrowed_item.set_status
      redirect_to user_items_path(@user.id)
    else
      render 'edit'
    end
  end

  def update_ext_status
    @borrowed_item = BorrowedItem.find(params[:borrowed_item_id])
    @item = Item.find(@borrowed_item.item_id)
    if params[:result] == "approved"
      @borrowed_item.approve_req
      @borrowed_item.update_due_date
      @borrowed_item.save
      
      redirect_to  user_items_path(params[:user_id])
    elsif params[:result] == "denied"
      @on_hold_item.reject_req
      @on_hold_item.save
      redirect_to  user_items_path(params[:user_id])
    end
  end

  def destroy
      @borrowed_item = @user.borrowed_items.find_by_item_id(@item_id)
      @borrowed_item.destroy
  end

  private
   def borrowed_item_params
     params.require(:borrowed_item).permit(:id,:item_id,:user_id, :due_date, :temp_due_date)
   end
end
