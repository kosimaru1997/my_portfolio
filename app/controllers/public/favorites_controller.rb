class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_user.favorite(@post)
    begin
      @post.create_notification_favorite!(current_user)
    rescue => e
      logger.error e
      logger.error e.backtrace.join("\n")
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.remove_favorite(@post)
    @post.reload
  end

end