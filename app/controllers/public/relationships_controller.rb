class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    unless current_user.following?(@user)
      if current_user.follow(@user)   #active_relationships.create(followed_id: params[:user_id])
        begin
          @user.create_notification_follow!(current_user)
        rescue => e
          logger.error e
          logger.error e.backtrace.join("\n")
        end
      end
    end
    #フォロー完了後のログインユーザーのフォロー情報を取得し条件分岐で使用。
    @login_user = current_user
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user) if current_user.following?(@user)
    @login_user = current_user
  end

end