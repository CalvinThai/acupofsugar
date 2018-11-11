class Item < ApplicationRecord
	searchkick text_middle: [:name]
	Item.reindex
	belongs_to :user
	has_many :wish_lists, dependent: :destroy
	has_many :borrowed_items, dependent: :destroy
	has_many :on_hold_items, dependent: :destroy

	scope :by_category, -> (category) { where('category = ?', category)}
	scope :by_status, -> (status) {where('status = ?', status)}

	Category = ['Technology', 'Pet']


	def self.item_search(params)
    query = params.slice(:page, :name, :status, :category)
		puts query[:name]

		results = self.agg_search(query) 

		puts "self item serach"


      return results.page(query[:page]) if query[:name].blank?
			puts query[:name]


			results_id = results.pluck(:id)
puts results_id
			self.elastic_search(query, results_id)



end


def self.agg_search(params)
	puts "simple search"
	puts params

	results = self.order('created_at DESC')
	results = results.by_category(params[:category]) if params[:category].present?
	results = results.by_status(params[:status]) if params[:status].present?
	results

end

def self.elastic_search(params, results_id)
	puts "elastic_search"
puts params
	if :name.present?

puts "name is present "
        @items = Item.search params[:name], operator: "or", fields: [:name], where: { id: results_id },match: :text_middle, misspellings: {below: 1}, per_page: 3
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
