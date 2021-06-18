class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      return  @posts = Post.search(params[:search]).includes(:user).page(params[:page]).reverse_order
    end
    @posts = Post.all.includes(:user).page(params[:page]).reverse_order
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy if post
    redirect_back(fallback_location: root_path)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment_count = @post.only_comment_count
    @post_comments = @post.post_comments.includes(:user).where(parent_id: nil).page(params[:page]).per(10).reverse_order
  end

end
