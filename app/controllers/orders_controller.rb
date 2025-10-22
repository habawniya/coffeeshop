class OrdersController < ApplicationController
  before_action :authenticate_user!



  def index
    if current_user.admin?
      @orders = Order.all.order(created_at: :desc)
    else 
    @orders = current_user.orders.includes(order_items: :item).order(created_at: :desc)
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
      end
    end

    redirect_to order_path(@order), notice: "Order updated successfully."
  end


 def remove_item
    @order = Order.find(params[:id]) 
    order_item = @order.order_items.find_by(id: params[:order_item_id])

    if order_item
      order_item.destroy
      notice = "Item removed successfully."
    else
      notice = "Item not found."
    end

    redirect_to order_path(@order), notice: notice
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

    # 1️⃣ Calculate subtotal and tax
    subtotal = 0
    total_tax = 0

    cart_items.each do |ci|
      item_price = ci.item.price * ci.quantity
      item_tax = item_price * (ci.item.tax_rate / 100.0)
      subtotal += item_price
      total_tax += item_tax
    end

    grand_total = subtotal + total_tax

    # 2️⃣ Apply automatic discount
    discount_amount = 0
    if grand_total >= 500
      discount_amount = grand_total * 0.10  # 10% discount
      grand_total -= discount_amount
    end

    # 3️⃣ Create Order with discount saved
    order = current_user.orders.create(
      status: "pending",
      discount_amount: discount_amount,
      total_price: grand_total
    )

    # 4️⃣ Convert CartItems → OrderItems
    cart_items.each do |ci|
      item_price = ci.item.price * ci.quantity
      item_tax = item_price * (ci.item.tax_rate / 100.0)
      total_price = item_price + item_tax
      
      order.order_items.create(
        item: ci.item,
        quantity: ci.quantity,
        price: total_price  # price including tax
      )
    end

    # 5️⃣ Clear cart
    cart_items.destroy_all

    redirect_to order_path(order), notice: "Order placed successfully!"
  end

  def show
    if current_user.admin?
    @order = Order.find(params[:id])
    else 
    @order = current_user.orders.find(params[:id])
    end 
    # 4️⃣ Dynamic Tax Calculation
    @subtotal = @order.order_items.sum { |oi| oi.item.price * oi.quantity }
    @total_tax = @order.order_items.sum { |oi| oi.item.price * oi.quantity * (oi.item.tax_rate / 100.0) }
    @discount = @order.discount_amount || 0

    @grand_total = @subtotal + @total_tax  - @discount

  end
end
