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
      
      @notif = Notification.find_by_user_id(@borrowed_item.user_id)
      lender = User.find(@item.user_id)
      borrower = User.find(@borrowed_item.user_id)
      #add due date smart alerts for borrower to the delay queue 
      #email will be sent 1 week before, 3 days before and the day before due date
      duration = ((@borrowed_item.due_date.to_i - Time.now.to_i) / 1.day)
      # puts "@@@@@@@@@@@@@@@@@@@@@ duration = #{duration} days"
      if @notif.i_due_alert
        if duration-7 > 0
          #puts "@@@@@@@@@@@@@@@@@adding 1 week pre-notification"
          SendEmailJob.set(wait: (duration-7).minutes).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
        end
        if duration-3 > 0
          #puts "@@@@@@@@@@@@@@@@@adding 3 days pre-notification"
          SendEmailJob.set(wait: (duration-3).minutes).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
        end
        if duration-1 > 0
          #puts "@@@@@@@@@@@@@@@@@adding 1 day pre-notification"
          SendEmailJob.set(wait: (duration-1).minutes).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
        end
      end
      #unconditional mailer to be delivered to both lender/borrower on due date
      #puts "@@@@@@@@@@@@@@@@@adding due notification for borrower"
      SendEmailJob.set(wait: duration.minutes).perform_later(lender.id, borrower.id, @item.id, "Borrower")
      #puts "@@@@@@@@@@@@@@@@@adding due notification for lender"
      SendEmailJob.set(wait: duration.minutes).perform_later(lender.id, borrower.id, @item.id, "Lender")
      #pick up confirmation email to both users - send instantly
      UserMailer.confirm_pickup(borrower, @item).deliver_later 
      UserMailer.confirm_pickup(lender, @item).deliver_later 
      
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
      #conditional mailer
      #send extension request alert to lender
      @notif = Notification.find_by_user_id(@item.user.id)
      if @notif.i_req_by_others
        lender = User.find(@item.user_id)
        borrower = User.find(@borrowed_item.user_id)
        UserMailer.new_extension_request(lender, borrower, @item).deliver_later       
      end
      redirect_to user_items_path(@user.id)
    else
      render 'edit'
    end
  end

  def update_ext_status
    @borrowed_item = BorrowedItem.find(params[:borrowed_item_id])
    @item = Item.find(@borrowed_item.item_id)
    @notif = Notification.find_by_user_id(@borrowed_item.user_id)
    lender = User.find(@item.user_id)
    borrower = User.find(@borrowed_item.user_id)
    if params[:result] == "approved"
        @borrowed_item.approve_req
        @borrowed_item.update_due_date
         @borrowed_item.save
        #send extension status update to borrower
          if @notif.i_req_approval_alert
            UserMailer.accept_extension_request(lender, borrower, @item, params[:result]).deliver_later
          end
          #add new due date smart alerts for borrower to the delay queue 
          #email will be sent 1 week before, 3 days before and the day before due date
          duration = ((@borrowed_item.due_date.to_i - Time.now.to_i) / 1.day)
          #puts "@@@@@@@@@@@@@@@@@@@@@ duration = #{duration} days"
          if @notif.i_due_alert
            if duration-7 > 0
              #puts "@@@@@@@@@@@@@@@@@adding 1 week pre-notification"
              SendEmailJob.set(wait: (duration-7).minutes).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
            end
            if duration-3 > 0
              #puts "@@@@@@@@@@@@@@@@@adding 3 days pre-notification"
              SendEmailJob.set(wait: (duration-3).minutes).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
            end
            if duration-1 > 0
             # puts "@@@@@@@@@@@@@@@@@adding 1 day pre-notification"
              SendEmailJob.set(wait: (duration-1).minutes).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
            end
          end
          #unconditional mailer to be delivered to both lender/borrower on due date
          #puts "@@@@@@@@@@@@@@@@@adding due notification for borrower"
          SendEmailJob.set(wait: duration.minutes).perform_later(lender.id, borrower.id, @item.id, "Borrower")
          #puts "@@@@@@@@@@@@@@@@@adding due notification for lender"
          SendEmailJob.set(wait: duration.minutes).perform_later(lender.id, borrower.id, @item.id, "Lender")
      redirect_to  user_items_path(params[:user_id])
    elsif params[:result] == "denied"
      @borrowed_item.reject_req
      @borrowed_item.save
      #send extension status update to borrower
      if @notif.i_req_approval_alert
        UserMailer.accept_extension_request(lender, borrower, @item, params[:result]).deliver_later
      end
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
