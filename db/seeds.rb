# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Site.find_or_create_by!(name: "Acme Corp") do |site|
  site.description = "A leading provider of innovative solutions for businesses worldwide."
  site.company_name = "Acme Corporation"
  site.company_address = "123 Business St, San Francisco, CA 94105"
  site.company_tax_id = "12-3456789"
  site.is_active = true
end

Site.find_or_create_by!(name: "TechStart Inc") do |site|
  site.description = "Building the future of technology with cutting-edge software products."
  site.company_name = "TechStart Inc."
  site.company_address = "456 Innovation Ave, Palo Alto, CA 94301"
  site.company_tax_id = "98-7654321"
  site.is_active = true
end

Site.find_or_create_by!(name: "Green Energy Co") do |site|
  site.description = "Sustainable energy solutions for a cleaner tomorrow."
  site.company_name = "Green Energy Company"
  site.company_address = "789 Eco Lane, Portland, OR 97201"
  site.company_tax_id = "55-444333222"
  site.is_active = true
end

Site.find_or_create_by!(name: "Inactive Corp") do |site|
  site.description = "This site is inactive."
  site.company_name = "Inactive Corporation"
  site.company_address = "123 Old St, Boston, MA 02101"
  site.company_tax_id = "11-1111111"
  site.is_active = false
end
