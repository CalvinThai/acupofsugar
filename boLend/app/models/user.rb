class User < ApplicationRecord
  #searchkick gem
  searchkick
  User.reindex
  #has_friendship gem
  has_friendship
  
  has_many :items, dependent: :destroy
  has_many :wish_lists, dependent: :destroy
  has_many :borrowed_items, dependent: :destroy
  has_many :on_hold_items, dependent: :destroy
  	
  def self.user_search(name)
    if name.present?    
        name = name.gsub(/[^0-9A-Za-z\s]/, '')
        @users = User.search name, operator: "or", fields: [:lname,:fname], misspellings: {edit_distance: 3}, limit: 5 
    else
      return nil
    end
  end
end
