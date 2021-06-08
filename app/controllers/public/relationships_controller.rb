class Public::RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    current_user.active_relationships.create(followed_id: params[:user_id])
    @login_user = User.includes(:following).find(current_user.id)
    @user.create_notification_follow!(current_user)
  end

  def destroy
    @user = User.find(params[:user_id])
    relationship = current_user.active_relationships.find_by(followed_id: params[:user_id])
    relationship.destroy if relationship
    # redirect_back(fallback_location: root_path)
    @login_user = User.includes(:following).find(current_user.id)
  end

end
