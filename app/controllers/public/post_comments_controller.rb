# frozen_string_literal: true

class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :same_user!, only: [:destroy]
  before_action :ensure_normal_user, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    # セーブできた場合、通知を作成し、ペアレントIDが存在したらrennder'create_reply'、無い場合はif文終了後create.js.erbへ。
    if @comment.save
      # ここで例外が発生した場合、コメントのセーブができていないと勘違いしたユーザーがcreateを連続で行うことを回避し、エラーログの出力に留める。
      begin
        @post.create_notification_comment!(current_user, @comment.id)
      rescue StandardError => e
        logger.error e
        logger.error e.backtrace.join("\n")
      end
      render 'create_reply' unless @comment.parent_id.nil?
    else
      render 'error_comment'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = PostComment.find_by(id: params[:id])
    return unless @comment

    @comment.destroy
    render 'destroy_reply' unless @comment.parent_id.nil?
  end

  # N+１問題に対応するため、repliesをポスト詳細ページにてAjaxで表示するメソッド
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
    redirect_to request.referer unless PostComment.find_by(id: params[:id]).user == current_user
  end

  def ensure_normal_user
    return unless current_user.email == 'guest@example.com'

    sample_user_ids = User.where(name: 'キータ').or(User.where(name: 'Zenn').or(User.where(name: 'railsエンジニア'))
    .or(User.where(email: 'guest@example.com'))).pluck(:id)
    post_user_id = Post.find(params[:post_id]).user_id
    redirect_to request.referer, alert: 'ゲストユーザーは特定のユーザーにしかコメントできません。' unless sample_user_ids.include?(post_user_id)
  end
end
