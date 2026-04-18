require "test_helper"

class RateCardTest < ActiveSupport::TestCase
  test "should be valid with required attributes" do
    site = sites(:active_site)
    rate_card = RateCard.new(
      name: "Standard Rates",
      site: site,
      effective_from: Date.today,
      effective_to: Date.today + 1.year
    )
    assert rate_card.valid?
  end

  test "should require name" do
    site = sites(:active_site)
    rate_card = RateCard.new(site: site)
    assert_not rate_card.valid?
  end

  test "should require site" do
    rate_card = RateCard.new(name: "Test")
    assert_not rate_card.valid?
  end

  test "should belong to site" do
    rate_card = rate_cards(:one)
    site = sites(:active_site)
    assert_equal site, rate_card.site
  end

  test "should have many rate card items" do
    site = sites(:active_site)
    rate_card = RateCard.create!(
      name: "Test Card",
      site: site,
      effective_from: Date.today,
      effective_to: Date.today + 1.year
    )
    item = rate_card.rate_card_items.create!(
      role: "Developer",
      unit: "hour",
      price: 100,
      currency: "USD"
    )
    assert_equal rate_card, item.rate_card
  end
end
