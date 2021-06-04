class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_user.favorites.create(post_id: @post.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post)
    favorite.destroy if favorite
  end

end