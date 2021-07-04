# frozen_string_literal: true

class Admin::PostCommentsController < ApplicationController
  def index
    @comments = if params[:search].nil?
                  PostComment.includes(:user).page(params[:page]).reverse_order
                else
                  PostComment.search(params[:search]).includes(:user).page(params[:page]).reverse_order
                end
  end

  # リプライを表示するためのページ
  def show
    @post_comment = PostComment.find(params[:id])
    @user = @post_comment.user
    @comments = @post_comment.replies.includes(:user).page(params[:page]).reverse_order
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end
end
