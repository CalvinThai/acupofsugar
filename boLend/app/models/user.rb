class User < ApplicationRecord
	has_many :items
  	has_many :wishlists
  	
  def self.search(name)
    if name
      name = name.split(" ")
      @users = User.where("fname LIKE ? OR fname LIKE?", "%#{name[0]}%","%#{name[1]}%")
    end
  end
end
