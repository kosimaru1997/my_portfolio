class Public::HomesController < ApplicationController

  def top
    if user_signed_in?
      @post = current_user.posts.build
      @posts = current_user.feed.includes(:user, :favorites, :favorited_users, :post_comments).page(params[:page]).reverse_order
    end

      @errors = session[:errors]
      session[:errors] = nil if session[:errors]
  end

end