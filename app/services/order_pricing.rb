# app/services/order_pricing.rb
module OrderPricing
  Order_Price  = 500
  DISCOUNT_RATE = 0.10

  # Calculate pricing from cart items
  def from_cart(cart_items)
    subtotal = cart_items.sum { |ci| ci.item.price * ci.quantity }
    total_tax = cart_items.sum { |ci| ci.item.price * ci.quantity * (ci.item.tax_rate / 100.0) }
    grand_total = subtotal + total_tax

    discount = grand_total >= Order_Price ? grand_total * DISCOUNT_RATE : 0
    grand_total -= discount

    {
      subtotal: subtotal,
      total_tax: total_tax,
      discount: discount,
      grand_total: grand_total
    }
  end

  # Calculate pricing from an existing order
  def from_order(order)
    subtotal = order.order_items.sum { |oi| oi.item.price * oi.quantity }
    total_tax = order.order_items.sum { |oi| oi.item.price * oi.quantity * (oi.item.tax_rate / 100.0) }
    discount = order.discount_amount || 0
    grand_total = subtotal + total_tax - discount

    {
      subtotal: subtotal,
      total_tax: total_tax,
      discount: discount,
      grand_total: grand_total
    }
  end
end
