class Public::RepostsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    current_user.repost(@post)
    redirect_to request.referer
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.remove_repost(@post)
    redirect_to request.referer
  end

end
