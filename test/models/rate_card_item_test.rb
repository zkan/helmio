require "test_helper"

class RateCardItemTest < ActiveSupport::TestCase
  test "should be valid with required attributes" do
    site = sites(:active_site)
    rate_card = RateCard.create!(
      name: "Test Card",
      site: site,
      effective_from: Date.today,
      effective_to: Date.today + 1.year
    )
    item = RateCardItem.new(
      rate_card: rate_card,
      role: "Developer",
      unit: "hour",
      price: 100,
      currency: "USD"
    )
    assert item.valid?
  end

  test "should require rate_card" do
    item = RateCardItem.new(role: "Developer")
    assert_not item.valid?
  end

  test "should require role" do
    site = sites(:active_site)
    rate_card = RateCard.create!(
      name: "Test Card",
      site: site,
      effective_from: Date.today,
      effective_to: Date.today + 1.year
    )
    item = RateCardItem.new(rate_card: rate_card)
    assert_not item.valid?
  end

  test "should require price" do
    site = sites(:active_site)
    rate_card = RateCard.create!(
      name: "Test Card",
      site: site,
      effective_from: Date.today,
      effective_to: Date.today + 1.year
    )
    item = RateCardItem.new(rate_card: rate_card, role: "Developer")
    assert_not item.valid?
  end

  test "should belong to rate_card" do
    site = sites(:active_site)
    rate_card = RateCard.create!(
      name: "Test Card",
      site: site,
      effective_from: Date.today,
      effective_to: Date.today + 1.year
    )
    item = RateCardItem.create!(
      rate_card: rate_card,
      role: "Developer",
      unit: "hour",
      price: 100,
      currency: "USD"
    )
    assert_equal rate_card, item.rate_card
  end
end
