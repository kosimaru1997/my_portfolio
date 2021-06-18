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

end
