class RateCardItem < ApplicationRecord
  belongs_to :rate_card

  validates :rate_card, presence: true
  validates :role, presence: true
  validates :price, presence: true
end
