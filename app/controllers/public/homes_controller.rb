class Public::HomesController < ApplicationController

  def top
    if user_signed_in?
      @post = current_user.posts.build
      @posts = current_user.feed.includes(:user).page(params[:page]).reverse_order
    end
  end

end