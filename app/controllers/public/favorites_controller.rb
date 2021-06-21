class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    if current_user.favorite(@post)
      begin
        @post.create_notification_favorite!(current_user)
      rescue => e
        logger.error e
        logger.error e.backtrace.join("\n")
      end
    end
    @login_user = User.includes(:favorites).find(current_user.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.remove_favorite(@post)
    @post.reload
    @login_user = User.includes(:favorites).find(current_user.id)
  end

end