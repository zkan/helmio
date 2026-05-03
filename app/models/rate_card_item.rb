class RateCardItem < ApplicationRecord
  belongs_to :rate_card
  has_many :crew_rate_card_items
  has_many :crews, through: :crew_rate_card_items

  validates :rate_card, presence: true
  validates :role, presence: true
  validates :price, presence: true

  def name
    "#{rate_card.name} - #{role}"
  end
end
