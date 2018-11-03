class User < ApplicationRecord
  #searchkick gem
  searchkick
  User.reindex
  
	has_many :items
  	has_many :wishlists
  	
  def self.user_search(name)
    if name.present?              
        @users = User.search name, operator: "or", fields: [:lname,:fname], misspellings: {edit_distance: 3}, limit: 5 
    else
      return nil
    end
  end
end
