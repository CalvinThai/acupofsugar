class BorrowedItemsController < ApplicationController

  def create
    @borrowed_item = @user.borrowed_items.create(borrowed_item_params)
  end
  def destroy
      @borrowed_item = @user.borrowed_items.find_by_item_id(@item_id)
      @borrowed_item.destroy
  end



  private
   def borrowed_item_params
     params.permit(:id,:item_id,:user_id, :due_date)
   end
end
