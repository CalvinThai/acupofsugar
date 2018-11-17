class ReviewBorrower < ApplicationRecord
	belongs_to :item
	belongs_to :user
	validates :rating, numericality: { greater_than: 0, less_than: 6 }
end
