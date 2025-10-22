class OrderNotificationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
   stream_from "order_notifications_#{current_user.id}"

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
