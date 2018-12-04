class WelcomeController < ApplicationController
  def index
    @items = Item.last(3)
  end
end
