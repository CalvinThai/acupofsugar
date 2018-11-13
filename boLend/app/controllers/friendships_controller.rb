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
    elsif params[:decision]=="false"
      @user.decline_request(@requirer)
    else
      @user.block_friend(@requirer)
    end
    respond_to do |format|
        format.js 
    end
  end
  
  def destroy
    @friend_remover = User.find(params[:friend_remover])
    @friend_removee = User.find(params[:friend_removee])
    @decision = params[:decision]
    if @decision=="unfriend"
      @friend_remover.remove_friend(@friend_removee)
    elsif @decision=="block"
      @friend_remover.block_friend(@friend_removee)
    else
      @friend_remover.unblock_friend(@friend_removee)
    end
    @user = @friend_remover
    respond_to do |format|
        format.js 
    end
  end
end
