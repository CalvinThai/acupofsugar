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

  def update
    @user = User.find(params[:friend_requiree])
    @requirer = User.find(params[:friend_requirer])
    if params[:decision]=="true"
      @user.accept_request(@requirer)
    else
      @user.decline_request(@requirer)
    end
    respond_to do |format|
        format.js 
    end
  end
  
  def destroy
    @friend_remover = User.find(params[:friend_remover])
    @friend_removee = User.find(params[:friend_removee])
    @friend_remover.remove_friend(@friend_removee)
    @user = @friend_remover
    respond_to do |format|
        format.js 
    end
  end
end
