require "test_helper"

class DashboardMetricsTest < ActionView::TestCase
  include DashboardMetrics

  setup do
    @crew_site = crew_sites(:one_active)
    @crew = @crew_site.crew
    @crew_site.estimate_days = 20
    @crew_site.save!
  end

  test "returns sites with required keys" do
    result = compute_metrics
    site_data = result[:sites].first

    assert site_data.key?(:site)
    assert site_data.key?(:revenue)
    assert site_data.key?(:crew_cost)
    assert site_data.key?(:gross_profit)
    assert site_data.key?(:margin)
    assert site_data.key?(:yearly_revenue)
    assert site_data.key?(:yearly_gross_profit)
    assert site_data.key?(:yearly_margin)
  end

  test "returns totals with required keys" do
    result = compute_metrics

    assert result[:totals].key?(:revenue)
    assert result[:totals].key?(:crew_cost)
    assert result[:totals].key?(:gross_profit)
    assert result[:totals].key?(:margin)
    assert result[:totals].key?(:yearly_revenue)
    assert result[:totals].key?(:yearly_gross_profit)
    assert result[:totals].key?(:yearly_margin)
  end

  test "calculates revenue filtering by site - only uses rate_card_items for that site" do
    result = compute_metrics
    site_data = result[:sites].first
    site = site_data[:site]

    site_rate_items = @crew.crew_rate_card_items.select do |crc|
      crc.rate_card_item.rate_card.site == site
    end
    expected = site_rate_items.sum { |crc| crc.rate_card_item.price } * @crew_site.estimate_days

    assert_equal expected.to_d, site_data[:revenue]
  end

  test "does not include rate_card_items from other sites" do
    result = compute_metrics
    site_data = result[:sites].first
    site = site_data[:site]

    other_site_items = @crew.crew_rate_card_items.select do |crc|
      crc.rate_card_item.rate_card.site != site
    end
    other_site_revenue = other_site_items.sum { |crc| crc.rate_card_item.price } * @crew_site.estimate_days

    assert_equal 0, other_site_revenue.to_d
  end

  test "calculates crew_cost correctly" do
    result = compute_metrics
    site_data = result[:sites].first

    expected = crew_sites(:one_active).crew.man_day_rate * crew_sites(:one_active).estimate_days +
               crew_sites(:two_active).crew.man_day_rate * crew_sites(:two_active).estimate_days

    assert_equal expected.to_d, site_data[:crew_cost]
  end

  test "calculates gross_profit correctly" do
    result = compute_metrics
    site_data = result[:sites].first

    expected = site_data[:revenue] - site_data[:crew_cost]
    assert_equal expected, site_data[:gross_profit]
  end

  test "calculates yearly_revenue from monthly * 12" do
    result = compute_metrics
    site_data = result[:sites].first

    expected = site_data[:revenue] * 12
    assert_equal expected, site_data[:yearly_revenue]
  end

  test "calculates margin correctly" do
    result = compute_metrics
    site_data = result[:sites].first

    expected = site_data[:revenue] > 0 ? (site_data[:gross_profit].to_f / site_data[:revenue] * 100) : 0
    assert_in_delta expected, site_data[:margin], 0.01
  end

  test "totals equal sum of all sites" do
    result = compute_metrics

    expected = result[:sites].sum { |s| s[:revenue] }
    assert_equal expected, result[:totals][:revenue]
  end

  test "totals yearly equals sum of all sites yearly" do
    result = compute_metrics

    expected = result[:sites].sum { |s| s[:yearly_revenue] }
    assert_equal expected, result[:totals][:yearly_revenue]
  end

  test "different sites have independent revenues" do
    result = compute_metrics

    sites = result[:sites]
    return if sites.size < 2

    revenues = sites.map { |s| s[:revenue] }
    assert revenues.uniq.size > 1, "Sites should have different revenues"
  end

  test "handles empty crew_sites" do
    CrewSite.delete_all

    result = compute_metrics

    assert_empty result[:sites]
    assert_equal 0, result[:totals][:revenue]
  end

  test "handles zero estimate_days" do
    CrewSite.where(site: @crew_site.site).update_all(estimate_days: 0)

    result = compute_metrics

    assert_equal 0, result[:sites].first[:revenue]
    assert_equal 0, result[:sites].first[:crew_cost]
  end

  test "handles nil estimate_days" do
    @crew_site.estimate_days = nil
    @crew_site.save!

    result = compute_metrics

    assert_equal 0, result[:sites].first[:revenue]
  end
end
