class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
#    Code before using Ajax
#    @user = User.find(params[:relationship][:followed_id])
#    current_user.follow!(@user)
#    redirect_to @user

    # Listing 12.36 - using Ajax
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
    
  end

  def destroy
#    Code before using Ajax
#    @user = Relationship.find(params[:id]).followed
#    current_user.unfollow!(@user)
#    redirect_to @user

    # Listing 12.36 - using Ajax
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end