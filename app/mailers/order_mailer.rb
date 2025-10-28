class OrderMailer < ApplicationMailer
     default from: 'no-reply@yourapp.com'  # Change to your sender email

  def order_ready_email(order)
    @order = order
    @user = order.user
    mail(
      to: @user.email,
      subject: "Your order ##{@order.id} is ready!"
    )
  end

  def order_completed_email(order)
    @order = order
    @user = order.user
    mail(
      to: @user.email,
      subject: "Your order ##{@order.id} is completed!"
    )
  end

  def order_cancelled_email(order)
    @order = order
    @user = order.user
    mail(
      to: @user.email,
      subject: "Your order ##{@order.id} is cancelled successfully"
    )
  end
end
