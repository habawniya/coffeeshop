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


Item.find_or_create_by!(name: "Cappuccino") do |item|
  item.price = 150
  item.description = "Delicious cappuccino with frothy milk"
  item.image.attach(
    io: File.open(Rails.root.join("db/seeds/images/cappuccino.jpg")),
    filename: "cappuccino.jpg",
    content_type: "image/jpeg"
  )
end


