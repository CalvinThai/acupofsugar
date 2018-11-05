class LendItemsController < ApplicationController
  def create
	end
	def update
	end
	def destroy
  end
  def update_request_status
    @on_hold_item = On_hold_item.find(params[:hold_id])
    if params[:result] == "approved"
      @on_hold_item.approve_req
      @on_hold_item.save
    elsif params[:result] == "denied"
      @on_hold_item.reject_req
      @on_hold_item.save
    end
  end
end
