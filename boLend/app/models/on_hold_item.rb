class OnHoldItem < ApplicationRecord
	belongs_to :item
	belongs_to :user

	def approve_req
		update_attributes(approved: 'Approved')
	end

	def reject_req
		update_attributes(approved: 'Denied')
	end
end
