class User < ApplicationRecord
	has_many :items, dependent: :destroy
  has_many :wish_lists, dependent: :destroy
  has_many :borrowed_items, dependent: :destroy
	has_many :on_hold_items, dependent: :destroy
  
  def self.search(name)
    if name
      name = name.split(" ")
      @users = User.where("fname LIKE ? OR fname LIKE?", "%#{name[0]}%","%#{name[1]}%")
    end
  end
end
