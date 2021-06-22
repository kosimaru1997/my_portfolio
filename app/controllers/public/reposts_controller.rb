class Public::RepostsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    if current_user.repost(@post)
      begin
        @post.create_notification_repost!(current_user)
      rescue => e
        logger.error e
        logger.error e.backtrace.join("\n")
      end
    end
    @post.reload
    @login_user = current_user
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.remove_repost(@post)
    @post.reload
    @login_user = current_user
  end

end
