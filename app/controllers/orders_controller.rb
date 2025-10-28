class OrdersController < ApplicationController
  include OrderPricing

  before_action :authenticate_user!

  def index
    @orders = if current_user.admin?
                Order.all.order(created_at: :desc)
              else
                current_user.orders.includes(order_items: :item).order(created_at: :desc)
              end
  end

  def update
    @order = Order.find(params[:id])
    if params[:status].present?
      @order.update(status: params[:status])

      if @order.status == 'ready'
        @order.user.notifications.create(
          message: "Your order ##{@order.id} is ready!",
          read: false
        )
        OrderMailer.order_ready_email(@order).deliver_later
      
       elsif @order.status == 'completed'
        @order.user.notifications.create(
          message: "Your order ##{@order.id} is completed!",
          read: false
        )
        OrderMailer.order_completed_email(@order).deliver_later       

       elsif @order.status == 'cancelled'
        @order.user.notifications.create(
          message: "Your order ##{@order.id} is cancelled",
          read: false
        )
        OrderMailer.order_cancelled_email(@order).deliver_later        
      end
    end

    redirect_to order_path(@order), notice: "Order updated successfully."
  end

  def remove_item
    @order = Order.find(params[:id])
    order_item = @order.order_items.find_by(id: params[:order_item_id])

    message = if order_item&.destroy
                "Item removed successfully."
              else
                "Item not found."
              end

    redirect_to order_path(@order), notice: message
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    cart_items = current_user.cart_items.includes(:item)
    if cart_items.empty?
      redirect_to items_path, alert: "Your cart is empty."
      return
    end

    # Use pricing module
    pricing = from_cart(cart_items)

    order = current_user.orders.create(
      status: "pending",
      discount_amount: pricing[:discount],
      total_price: pricing[:grand_total]
    )

    # Create order items
    cart_items.each do |ci|
      item_price = ci.item.price * ci.quantity
      item_tax = item_price * (ci.item.tax_rate / 100.0)
      total_price = item_price + item_tax

      order.order_items.create(
        item: ci.item,
        quantity: ci.quantity,
        price: total_price
      )
    end

    cart_items.destroy_all
    redirect_to order_path(order), notice: "Order placed successfully!"
  end

  def show
    @order = current_user.admin? ? Order.find(params[:id]) : current_user.orders.find(params[:id])
    pricing = from_order(@order)
    @discount = 0
    @subtotal = pricing[:subtotal]
    @total_tax = pricing[:total_tax]
    @discount = pricing[:discount]
    @grand_total = pricing[:grand_total]
  end
end
