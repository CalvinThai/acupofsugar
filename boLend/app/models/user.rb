class User < ApplicationRecord
	has_many :items
  	has_many :wishlists
  	
  def self.search(name)
    if name
      @users = User.where('name LIKE ?', "%#{name}%")
    end
  end
end
