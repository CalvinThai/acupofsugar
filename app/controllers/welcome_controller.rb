class WelcomeController < ApplicationController
  skip_before_action :require_login
  def index
    @items = Item.first(3)
  end
end
