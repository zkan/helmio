class CrewRateCardItem < ApplicationRecord
  belongs_to :crew
  belongs_to :rate_card_item

  validates :crew, presence: true
  validates :rate_card_item, presence: true
  validates :crew_id, uniqueness: { scope: :rate_card_item_id }
end