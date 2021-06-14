class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)   #active_relationships.create(followed_id: params[:user_id])
    @user.create_notification_follow!(current_user)
    @login_user = User.includes(:following).find(current_user.id)
  end

  def destroy
    @user = User.find(params[:user_id])
    relationship = current_user.active_relationships.find_by(followed_id: params[:user_id])
    relationship.destroy if relationship
    # redirect_back(fallback_location: root_path)
    @login_user = User.includes(:following).find(current_user.id)
  end

end
