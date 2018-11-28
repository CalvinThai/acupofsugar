require 'sidekiq/api'

class SendEmailJob < ApplicationJob
  queue_as :default
  before_perform :destroy_on_change
  after_perform :create_next_alert

  discard_on ActiveJob::DeserializationError

  def perform(lender_id, borrower_id, item_id, to_which)
  	@lender = User.find(lender_id)
  	@borrower = User.find(borrower_id)
  	@item = Item.find(item_id)
  	borrowed_item = BorrowedItem.find_by_item_id(item_id)
  	@days = ((borrowed_item.due_date.to_i - Time.now.to_i) / 1.day) 
  	# puts "@@@@@@@@@@@@@@@@@@@@@ duration = #{@days}"
    # Deliver due date email
    if(to_which == "smart_alert") 
    	UserMailer.smart_due_date_alert(@borrower, @item, @days).deliver_now
    elsif(to_which == "Lender")
    	UserMailer.due_date_alert(@lender, @item).deliver_now
    else
    	UserMailer.due_date_alert(@borrower, @item).deliver_now
    end
  end

  #need to access self.arg in diff way<<<<<<<<<<<<<<<<<<
  # in case if user's notification preferences has changed to false
  # or if due date has been extended, the current notification will be dequeued
  # also handles if user does not exist anymore
  def destroy_on_change
  	@item = BorrowedItem.find_by_item_id(self.arg[2])
  	@notif_borrower = Notification.find_by_user_id(self.arg[1])
  	@borrower = User.find(self.arg[1])
  	@lender = User.find(self.arg[0])
  	delete = true
  	if(self.arg[3] == "smart_alert")
  		if(@borrower)
  			delete = false
  		end
	  	if(@notif_borrower)
	  		if(@notif_borrower.i_due_alert)
	  			delete = false
	  		end
	  	end
	  	if(@item)
	  		due = @item.due_date
	  		due_ext = @item.temp_due_date
	  		if(due_ext == nil)
	  			delete = false
	  		end
	  	end 
	  	if(delete)
	  		self.delete
	  	end
	else
		if(!@lender)
			self.delete
		end
  	end 	
  end

  #create next alert that will send user emails after due date
  def create_next_alert
  	@item = BorrowedItem.find_by_item_id(self.arg[2])
  	if(self.arg[3] == "smart_alert" && @item && @item.returned_on == nil)
  		SendEmailJob.set(wait: 10.minutes).perform_later(lender.id, borrower.id, @item.id, "Borrower")
  	end
  end
end
