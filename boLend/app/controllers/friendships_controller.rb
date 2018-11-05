class FriendshipsController < ApplicationController
  def create
    #render plain: params[:friend_requirer].inspect
    @friend_requirer = User.find(params[:friend_requirer])
    @friend_requiree = User.find(params[:friend_requiree])
    @friend_requirer.friend_request(@friend_requiree)
    @user = @friend_requirer
    @users = User.user_search(params[:name])
    respond_to do |format|               
        format.js 
    end 
  end
  
end
