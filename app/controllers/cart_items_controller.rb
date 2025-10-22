class CartItemsController < ApplicationController
  before_action :authenticate_user!
	def index
	@cart_items = current_user.cart_items.includes(:item)

	@subtotal = 0
	@tax_total = 0

	# Calculate subtotal and tax
	@cart_items.each do |cart_item|
		item_price = cart_item.item.price * cart_item.quantity
		item_tax = item_price * (cart_item.item.tax_rate / 100.0)

		@subtotal += item_price
		@tax_total += item_tax
	end

	@grand_total = @subtotal + @tax_total

	# Apply automatic discount if grand_total >= 500
	@discount = 0
	if @subtotal >= 500
		@discount = @grand_total * 0.10  # 10% discount
		@grand_total -= @discount
	end
	end


	def create
		@item = Item.find(params[:item_id])
		@cart_item = current_user.cart_items.find_or_initialize_by(item: @item)
		@cart_item.quantity ||= 0
		@cart_item.quantity += 1

		if @cart_item.save
		redirect_to cart_items_path, notice: "Item added to cart!"
		else
		redirect_to items_path, alert: "Unable to add item."
		end
	end



	def update
		@cart_item = current_user.cart_items.find(params[:id])
		new_quantity = params[:quantity].to_i

		if new_quantity > 0
			@cart_item.update(quantity: new_quantity)
		else
			@cart_item.destroy
		end

		redirect_to cart_items_path, notice: "Cart updated."
	end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "Item removed from cart."
  end
end
