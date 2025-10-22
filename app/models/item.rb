class Item < ApplicationRecord
  has_many :cart_items
  belongs_to :category
  has_one_attached :image  
end
