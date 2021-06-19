class Unlogin::PostsController < ApplicationController

  def index
    @posts = Post.all.includes(:user).page(params[:page]).reverse_order
  end

end
