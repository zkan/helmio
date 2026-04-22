class Site < ApplicationRecord
  has_many :crew_sites
  has_many :crews, through: :crew_sites
end
