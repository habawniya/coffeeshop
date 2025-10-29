module OrderPricing
  ORDER_PRICE = 500
  DISCOUNT_RATE = 0.10

  def from_cart(cart_items)
    subtotal = 0
    total_tax = 0

    cart_items.each do |ci|
      item_price = ci.item.price * ci.quantity
      item_tax = item_price * (ci.item.tax_rate / 100.0)

      subtotal += item_price
      total_tax += item_tax
    end

    grand_total = subtotal + total_tax

    discount = grand_total >= ORDER_PRICE ? grand_total * DISCOUNT_RATE : 0
    grand_total -= discount

    {
      subtotal: subtotal,
      total_tax: total_tax,
      discount: discount,
      grand_total: grand_total
    }
  end

  def from_order(order)
    subtotal = 0
    total_tax = 0

    order.order_items.each do |oi|
      item_price = oi.item.price * oi.quantity
      item_tax = item_price * (oi.item.tax_rate / 100.0)

      subtotal += item_price
      total_tax += item_tax
    end

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
