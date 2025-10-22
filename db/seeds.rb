# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
Category.find_or_create_by(name: "Pizza").update(emoji: "🍕")
Category.find_or_create_by(name: "Cold Beverage").update(emoji: "🥤")
Category.find_or_create_by(name: "Hot Beverage").update(emoji: "☕")
Category.find_or_create_by(name: "Sandwich").update(emoji: "🥪")
Category.find_or_create_by(name: "Pasta").update(emoji: "🍝")
Category.find_or_create_by(name: "burger").update(emoji: "🍔")


User.find_or_create_by(email: "admin@gmail.com") do |user|
  user.password = "123456"
  user.password_confirmation = "123456"
  user.role = 1  
end

items_data = [
  { name: "paneer pizza", price: 260, tax_rate: 5, category_name: "Pizza", image: "paneer_pizza.jpeg" },
  { name: "Margherita Pizza", price: 250, tax_rate: 5, category_name: "Pizza", image: "margherita_pizza.webp" },
  { name: "Farmhouse Pizza", price: 300, tax_rate: 5, category_name: "Pizza", image: "farmhouse_pizza.jpeg" },
  { name: "Corn pizza", price: 230, tax_rate: 5, category_name: "Pizza", image: "corn_pizza.jpeg" },
  { name: "Mix veg pizza", price: 260, tax_rate: 5, category_name: "Pizza", image: "mix_veg_pizza.jpeg" },
  { name: "White sauce pasta", price: 200, tax_rate: 5, category_name: "Pasta", image: "white_sauce_pasta.jpeg" },
  { name: "Red Sauce Pasta", price: 220, tax_rate: 5, category_name: "Pasta", image: "red_sauce_pasta.jpeg" },
  { name: "Cheese sandwich", price: 140, tax_rate: 5, category_name: "Sandwich", image: "cheese_sandwich.jpeg" },
  { name: "Grilled sandwich", price: 180, tax_rate: 5, category_name: "Sandwich", image: "grilled_sandwich.jpeg" },
  { name: "Tandoori sandwich", price: 185, tax_rate: 5, category_name: "Sandwich", image: "tandoori_sandwich.jpeg" },
  { name: "Paneer sandwich", price: 260, tax_rate: 5, category_name: "Sandwich", image: "paneer_sandwich.jpeg" },
  { name: "Corn tandoori sandwich", price: 250, tax_rate: 5, category_name: "Sandwich", image: "corn_tandoori_sandwich.jpeg" },
  { name: "Club Sandwich", price: 280, tax_rate: 5, category_name: "Sandwich", image: "club_sandwich.jpeg" },
  { name: "Cappuccino", price: 95, category: "Hot Beverage", image: "cappuccino.jpeg" },
  { name: "Espresso", price: 120, category: "Hot Beverage", image: "espresso.jpeg" },
  { name: "Latte", price: 130, category: "Hot Beverage", image: "latte.jpeg" },
  { name: "Hot Chocolate", price: 130, category: "Hot Beverage", image: "hot_chocolate.jpeg" },
  { name: "Black Tea", price: 60, category: "Hot Beverage", image: "black_tea.jpeg" },
  { name: "Cold Coffee", price: 150, tax_rate: 5, category_name: "Cold Beverage", image: "cold_coffee.jpeg" },
  { name: "Strawberry Shake", price: 160, tax_rate: 5, category_name: "Cold Beverage", image: "strawberry_shake.jpeg" },
  { name: "Mango Shake", price: 160, tax_rate: 5, category_name: "Cold Beverage", image: "mango_shake.jpeg" },
  { name: "Chocolate Shake", price: 170, tax_rate: 5, category_name: "Cold Beverage", image: "chocolate_shake.jpeg" },
  { name: "Cheese Burger", price: 190, tax_rate: 5, category_name: "burger", image: "cheese_burger.jpeg" },
  { name: "Paneer Burger", price: 140, tax_rate: 5, category_name: "burger", image: "paneer_burger.jpeg" },
  { name: "Aloo Tikki Burger", price: 120, tax_rate: 5, category_name: "burger", image: "aloo_tikki_burger.jpeg" },
  { name: "Red Bull", price: 150, tax_rate: 5, category_name: "Cold Beverage", image: "red_bull.jpeg" },
  { name: "Alfredo Pasta", price: 260, tax_rate: 5, category_name: "Pasta", image: "alfredo_pasta.jpeg" },
  { name: "Berry Smoothie", price: 170, tax_rate: 5, category_name: "Cold Beverage", image: "berry_smoothie.jpeg" }
]


items_data.each do |attrs|
  category = Category.find_or_create_by!(name: attrs[:category_name])

  item = Item.find_or_create_by!(name: attrs[:name]) do |i|
    i.price = attrs[:price]
    i.tax_rate = attrs[:tax_rate]
    i.available = true
    i.category_id = category.id
  end

  image_path = Rails.root.join("db/seeds/images/#{attrs[:image]}")
  if File.exist?(image_path) && !item.image.attached?
    item.image.attach(
      io: File.open(image_path),
      filename: attrs[:image],
      content_type: "image/jpeg"
    )
  end
end