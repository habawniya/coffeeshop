class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:update, :destroy]

  def index
    @cart_items = current_user.cart_items.includes(:item)

    calculate_totals
  end

  def create
    item = Item.find(params[:item_id])
    cart_item = current_user.cart_items.find_or_initialize_by(item:)

    cart_item.quantity = (cart_item.quantity || 0) + 1

    if cart_item.save
      redirect_to cart_items_path, notice: "Item added to cart!"
    else
      redirect_to items_path, alert: "Unable to add item."
    end
  end

  def update
    new_quantity = params[:quantity].to_i

    if new_quantity.positive?
      @cart_item.update(quantity: new_quantity)
      message = "Cart updated."
    else
      @cart_item.destroy
      message = "Item removed from cart."
    end

    redirect_to cart_items_path, notice: message
  end

  def destroy
    @cart_item.destroy
    redirect_to cart_items_path, notice: "Item removed from cart."
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def calculate_totals
    @subtotal = @cart_items.sum { |cart_item| cart_item.item.price * cart_item.quantity }
    @tax_total = @cart_items.sum { |cart_item| (cart_item.item.price * cart_item.quantity) * (cart_item.item.tax_rate / 100.0) }
    @grand_total = @subtotal + @tax_total

	@discount = 0
    apply_discount if @subtotal >= 500
  end

  def apply_discount
    @discount = @grand_total * 0.10
    @grand_total -= @discount
  end
end
