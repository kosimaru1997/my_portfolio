# frozen_string_literal: true

class Public::HomesController < ApplicationController
  def top
    @post = current_user.posts.build
    @posts = current_user.followings_posts_with_reposts.page(params[:page]).reverse_order
    @login_user = User.includes(:favorites, :reposts).find(current_user.id)
  end

end
