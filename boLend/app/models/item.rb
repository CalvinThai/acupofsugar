class Item < ApplicationRecord
	belongs_to :user
	has_many :wish_lists, dependent: :destroy
	has_many :borrowed_items, dependent: :destroy
	has_many :on_hold_items, dependent: :destroy
end
