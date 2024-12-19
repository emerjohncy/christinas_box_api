# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Categories
necklaces = Category.create!(name: "Necklaces", status: "Active")
rings = Category.create!(name: "Rings", status: "Active")
earrings = Category.create!(name: "Earrings", status: "Active")
bracelets = Category.create!(name: "Bracelets", status: "Active")

# Create Products for Necklaces
necklaces.products.create!([
  { name: 'Gold Pendant Necklace', description: 'A beautiful gold pendant necklace, perfect for any occasion.', price: 11599.00 },
  { name: 'Silver Heart Necklace', description: 'A delicate silver heart necklace with intricate detailing.', price: 5399.00 },
  { name: 'Diamond Necklace', description: 'A stunning diamond necklace, perfect for weddings or special events.', price: 28999.00 },
  { name: 'Pearl Necklace', description: 'A classic pearl necklace with white pearls and gold clasp.', price: 7999.00 }
])

# Create Products for Rings
rings.products.create!([
  { name: 'Engagement Ring', description: 'A gorgeous engagement ring with a solitaire diamond in a platinum setting.', price: 45000.00 },
  { name: 'Gold Band Ring', description: 'A simple yet elegant gold band ring, perfect for everyday wear.', price: 9500.00 },
  { name: 'Silver Ring with Emerald', description: 'A beautiful silver ring featuring a vibrant emerald stone.', price: 14000.00 },
  { name: 'Wedding Ring Set', description: 'A matching wedding ring set made from white gold, includes the bride and groom bands.', price: 40000.00 }
])

# Create Products for Earrings
earrings.products.create!([
  { name: 'Diamond Stud Earrings', description: 'Elegant diamond stud earrings set in white gold.', price: 17500.00 },
  { name: 'Gold Hoop Earrings', description: 'Classic gold hoop earrings, a staple for every jewelry collection.', price: 3000.00 },
  { name: 'Pearl Drop Earrings', description: 'A pair of pearl drop earrings with a gold hook.', price: 5500.00 },
  { name: 'Chandelier Earrings', description: 'Stunning chandelier earrings with sparkling crystals.', price: 7999.00 }
])

# Create Products for Bracelets
bracelets.products.create!([
  { name: 'Gold Cuff Bracelet', description: 'A sleek and modern gold cuff bracelet for a minimalist look.', price: 8500.00 },
  { name: 'Silver Charm Bracelet', description: 'A charm bracelet made of sterling silver with various customizable charms.', price: 5000.00 },
  { name: 'Leather Wrap Bracelet', description: 'A stylish leather wrap bracelet with metal accents.', price: 2500.00 },
  { name: 'Diamond Tennis Bracelet', description: 'A luxury diamond tennis bracelet set in white gold.', price: 50000.00 }
])

puts "Seed data created successfully!"
