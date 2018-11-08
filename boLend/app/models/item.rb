class Item < ApplicationRecord
	searchkick text_middle: [:name]
	Item.reindex
	belongs_to :user
	has_many :wish_lists, dependent: :destroy
	has_many :borrowed_items, dependent: :destroy
	has_many :on_hold_items, dependent: :destroy

	def self.item_search(name)
    if name.present?
        name = name.gsub(/[^0-9A-Za-z\s]/, '')

        @items = Item.search name, operator: "or", fields: [:name], match: :text_middle, misspellings: {edit_distance: 3}, per_page: 3
		else
      @items = Item.all

    end

end


def self.status_filter(status)
	if status.present?


			@status_filter = Item.search status, operator: "or", fields: [:status], misspellings: {edit_distance: 3}
	else
		@status_filter = Item.all

	end

end


def self.category_filter(category)
	if category.present?


			@category_filter = Item.search category, operator: "or", fields: [:category], misspellings: {edit_distance: 3}
	else
		@category_filter = Item.all

	end

end
end
