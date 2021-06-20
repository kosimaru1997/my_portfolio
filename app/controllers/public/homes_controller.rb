class Public::HomesController < ApplicationController

  def top
    @post = current_user.posts.build
    @posts = current_user.feed.includes(:user).page(params[:page]).reverse_order
    @login_user = User.includes(:favorites).find(current_user.id)
  end

end