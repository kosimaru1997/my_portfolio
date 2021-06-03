class Public::RelationshipsController < ApplicationController
  
  def create
    current_user.active_relationships.create(followed_id: params[:user_id])
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    relationship = current_user.active_relationships.find_by(followed_id: params[:user_id])
    relationship.destroy if relationship
    redirect_back(fallback_location: root_path)
  end
  
end
