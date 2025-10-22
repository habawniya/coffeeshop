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


# item = Item.find_or_create_by!(name: "Paneer Pizza") do |i|
#   i.price = 260
#   i.tax_rate = 5
#   i.available = true
#   i.category_id = 1
# end

# item.image.attach(
#   io: File.open(Rails.root.join("db/seeds/images/download.jpeg")),
#   filename: "download.jpeg",
#   content_type: "image/jpeg"
# )


items_data = [
  { name: "paneer pizza", price: 260, tax_rate: 5, category_name: "Pizza", image: "paneer_pizza.jpeg" },
  { name: "Margherita Pizza", price: 250, tax_rate: 5, category_name: "Pizza", image: "margherita_pizza.webp" },
  { name: "Farmhouse Pizza", price: 300, tax_rate: 5, category_name: "Pizza", image: "farmhouse_pizza.jpeg" },
  { name: "corn pizza", price: 230, tax_rate: 5, category_name: "Pizza", image: "corn_pizza.jpg" },
  { name: "mix veg pizza", price: 260, tax_rate: 5, category_name: "Pizza", image: "mix_veg_pizza.jpg" }
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