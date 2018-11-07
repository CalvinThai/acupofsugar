class Item < ApplicationRecord
	searchkick
	Item.reindex
	belongs_to :user
	has_many :wish_lists, dependent: :destroy
	has_many :borrowed_items, dependent: :destroy
	has_many :on_hold_items, dependent: :destroy

	def self.item_search(name)
    if name.present?
        name = name.gsub(/[^0-9A-Za-z\s]/, '')

        @items = Item.search name, operator: "or", fields: [:name], misspellings: {edit_distance: 3}, limit: 5
		else
      @items = Item.all

    end

end

def self.item_agg(status)
if status.present?
			@aggs = Item.search "*", aggs: [:status], operator: "or", fields: [:name], misspellings: {edit_distance: 3}, limit: 5

else
@aggs
	end

end
end
