class Crew < ApplicationRecord
  has_many :crew_sites
  has_many :sites, through: :crew_sites
end
