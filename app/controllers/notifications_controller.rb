class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    # mark all as read
    @notifications.update_all(read: true)
  end
end
