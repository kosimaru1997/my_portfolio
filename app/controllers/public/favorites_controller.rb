# frozen_string_literal: true

class Public::FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    unless current_user.favorited?(@post)
      if current_user.favorite(@post)
        begin
          @post.create_notification_favorite!(current_user)
        rescue StandardError => e
          logger.error e
          logger.error e.backtrace.join("\n")
        end
        @post.reload
      end
    end
    @login_user = User.includes(:favorites).find(current_user.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.remove_favorite(@post) if current_user.favorited?(@post)
    @post.reload
    @login_user = User.includes(:favorites).find(current_user.id)
  end
end
