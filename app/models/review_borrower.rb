class ReviewBorrower < ApplicationRecord
	belongs_to :item
	belongs_to :user
	validates :rating,  presence: {message: "Please provide rating"}, numericality: { greater_than: 0, less_than: 6 }

	after_save :update_user_rating

	def update_user_rating(target_user = nil)
		target_user ||= self.borrower_id
		user = User.find(target_user)
		all_ratings = ReviewBorrower.select("review_borrowers.rating").where("review_borrowers.borrower_id = ?", target_user)
		rating_avg = all_ratings.average(:rating)
		if !rating_avg
			return			
		end
		if(!user.rating) 
			rating_old = 5 #start with rate 5
		else
			rating_old = user.rating
		end
		user.rating = [rating_old,rating_avg].sum / 2
		user.save
	end
end
