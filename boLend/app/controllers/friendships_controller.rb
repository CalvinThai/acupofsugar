class FriendshipsController < ApplicationController
  def create
    #render plain: params[:friend_requirer].inspect
    @friend_requirer = User.find(params[:friend_requirer])
    @friend_requiree = User.find(params[:friend_requiree])
    @friend_requirer.friend_request(@friend_requiree)
    
    redirect_to users_path
  end
  
end
