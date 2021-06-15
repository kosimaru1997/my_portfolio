class Public::HomesController < ApplicationController

  def top
    @post = current_user.posts.build
    @posts = current_user.feed.includes(:user, :favorited_users).page(params[:page]).reverse_order
  end

end