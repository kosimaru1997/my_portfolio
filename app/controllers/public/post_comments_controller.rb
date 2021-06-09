class Public::PostCommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment_reply = @post.post_comments.build
    @post_comments = @post.post_comments.where(parent_id: nil).includes(:user).page(params[:page]).reverse_order
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    @comment.save
    @post.create_notification_comment!(current_user, @comment.id)
    render "create_reply" if @comment.parent_id != []
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment_reply = @post.post_comments.build
    @post_comments = @post.post_comments.where(parent_id: nil).includes(:user).page(params[:page]).reverse_order
    @comment = PostComment.find_by(id: params[:id])
    @comment.destroy
    render "destroy_reply" if @comment.parent_id != []
  end

  private

    def post_comment_params
      params.require(:post_comment).permit(:comment, :parent_id)
    end

end
