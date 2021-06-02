class Public::PostCommentsController < ApplicationController
  
  def create
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = params[:post_id]
    comment.save
    redirect_to post_path(params[:post_id])
  end
  
  def destroy
    PostComment.find_by(id: params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end
  
  private
  
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
  
end
