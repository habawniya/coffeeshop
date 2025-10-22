class AddDiscountAmountToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :discount_amount, :decimal
  end
end
