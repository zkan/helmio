class RateCard < ApplicationRecord
  belongs_to :site
  has_many :rate_card_items, dependent: :destroy

  validates :name, presence: true
  validates :site, presence: true
end
