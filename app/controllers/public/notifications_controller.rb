class Public::NotificationsController < ApplicationController

  def index
    notifications_all = current_user.passive_notifications
    notifications_all.where(checked: false).each do |notification| # .update_all(checked: true)
      notification.update_attributes(checked: true)
    end
    @notifications = notifications_all.includes(:post, :post_comment, :visitor, :visited)
                                      .where.not(visitor_id: current_user.id).page(params[:page])
  end

end