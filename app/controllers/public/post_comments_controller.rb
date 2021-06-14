class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :same_user!, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    #セーブできた場合、通知を作成し、ペアレントIDが存在したらrennder'create_reply'、無い場合はif文終了後create.js.erbへ。
    if @comment.save
      #コメントのセーブができていないと勘違いしたユーザーがcreate処理を連続で行うことを回避し、エラーログの出力に留める。
      begin
        @post.create_notification_comment!(current_user, @comment.id)
      rescue => e
        logger.error e
        logger.error e.backtrace.join("\n")
      end
      render "create_reply" unless @comment.parent_id.nil?
    else
      render "error_comment"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = PostComment.find_by(id: params[:id])
    @comment.destroy if @co
    render "destroy_reply" unless @comment.parent_id.nil?
  end

  #N+１問題に対応するため、repliesをAjaxで表示するメソッド
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
