class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :same_user!, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @post_comments = @post.post_comments.where(parent_id: nil).includes(:user).page(params[:page]).reverse_order  #リプライを排除
    @comment_reply = @post.post_comments.build #リプライ用のフォーム
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save
      render "create_reply" unless @comment.parent_id.nil?
      @post.create_notification_comment!(current_user, @comment.id)
    else
      render "error_comment"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment_reply = @post.post_comments.build
    @post_comments = @post.post_comments.where(parent_id: nil).includes(:user).page(params[:page]).reverse_order
    @comment = PostComment.find_by(id: params[:id])
    @comment.destroy
    render "destroy_reply" unless @comment.parent_id.nil?
  end

  #repliesをAjaxでするためのメソッド
  def show
    post = Post.find(params[:post_id])
    @comment_reply = post.post_comments.build
    @comment = PostComment.find_by(id: params[:id])
    @replies = @comment.replies.includes(:user, :post)
  end

  private

    def post_comment_params
      params.require(:post_comment).permit(:comment, :parent_id)
    end

    def same_user!
      unless PostComment.find_by(id: params[:id]).user == current_user
        redirect_to request.referer
      end
    end

end
