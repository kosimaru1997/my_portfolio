class Public::NotificationsController < ApplicationController

  def index
    notifications_all = current_user.passive_notifications.page(params[:page])
    notifications_all.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    @notifications = notifications_all.includes([{ post: [:user] },:post_comment, :visitor, :visited]).where.not(visitor_id: current_user.id).page(params[:page])
  end

end