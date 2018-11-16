class BorrowedItem < ApplicationRecord
	belongs_to :item
	belongs_to :user

	def set_returned_date
		update_attributes(returned_on: Time.now.strftime("%d/%m/%Y"))
	end
end
