class User < ApplicationRecord
	has_many :items
  
  def self.search(name)
    if name
      @users = User.where('name LIKE ?', "%#{name}%")
    end
  end
end
