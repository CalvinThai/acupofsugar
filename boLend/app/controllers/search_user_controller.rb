class SearchUserController < ApplicationController
  def index
    @users_found = User.search(params[:name])
  end
  end
end
