class Public::PostCommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @post_comments = @post.post_comments
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @post_comments = @post.post_comments
    PostComment.find_by(id: params[:id]).destroy
  end
  
  private
  
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
  
end
