class Crew < ApplicationRecord
  has_many :crew_sites
  has_many :sites, through: :crew_sites
  has_many :crew_rate_card_items
  has_many :rate_card_items, through: :crew_rate_card_items
end
