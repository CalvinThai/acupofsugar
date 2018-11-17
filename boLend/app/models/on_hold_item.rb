class OnHoldItem < ApplicationRecord
	belongs_to :item
	belongs_to :user

	def approve_req
		update_attributes(approved: 'Approved')
	end

	def reject_req
		update_attributes(approved: 'Denied')
	end

	def returned
		update_attributes(approved: 'Returned')
	end

	def set_null
		update_attributes(approved: nil)
	end
end
