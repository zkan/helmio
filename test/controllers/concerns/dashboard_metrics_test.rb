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
    assert site_data.key?(:periods)
  end

  test "returns totals with required keys" do
    result = compute_metrics

    assert result[:totals].key?(:revenue)
    assert result[:totals].key?(:crew_cost)
    assert result[:totals].key?(:gross_profit)
    assert result[:totals].key?(:margin)
    assert result[:totals].key?(:by_period)
  end

  test "calculates revenue as sum of 12 months" do
    result = compute_metrics
    site_data = result[:sites].first

    monthly_revenue = @crew.crew_rate_card_items.sum { |crc| crc.rate_card_item.price } * @crew_site.estimate_days
    expected_revenue = monthly_revenue * 12

    assert_equal expected_revenue.to_d, site_data[:revenue]
  end

  test "calculates crew_cost as sum of 12 months" do
    result = compute_metrics
    site_data = result[:sites].first

    monthly_crew_cost = @crew.man_day_rate * @crew_site.estimate_days
    expected_crew_cost = monthly_crew_cost * 12

    assert_equal expected_crew_cost.to_d, site_data[:crew_cost]
  end

  test "calculates gross_profit as revenue minus crew_cost" do
    result = compute_metrics
    site_data = result[:sites].first

    expected = site_data[:revenue] - site_data[:crew_cost]
    assert_equal expected, site_data[:gross_profit]
  end

  test "calculates margin correctly" do
    result = compute_metrics
    site_data = result[:sites].first

    expected = site_data[:revenue] > 0 ? (site_data[:gross_profit].to_f / site_data[:revenue] * 100) : 0
    assert_in_delta expected, site_data[:margin], 0.01
  end

  test "returns 12 monthly periods for each site" do
    result = compute_metrics

    assert_equal 12, result[:sites].first[:periods].size
  end

  test "periods have required keys" do
    result = compute_metrics
    period = result[:sites].first[:periods].first

    assert period.key?(:month)
    assert period.key?(:revenue)
    assert period.key?(:crew_cost)
    assert period.key?(:gross_profit)
    assert period.key?(:margin)
  end

  test "each period calculates monthly value" do
    result = compute_metrics
    period = result[:sites].first[:periods].first

    expected_revenue = @crew.crew_rate_card_items.sum { |crc| crc.rate_card_item.price } * @crew_site.estimate_days
    expected_crew_cost = @crew.man_day_rate * @crew_site.estimate_days

    assert_equal expected_revenue.to_d, period[:revenue]
    assert_equal expected_crew_cost.to_d, period[:crew_cost]
  end

  test "totals equal sum of all sites" do
    result = compute_metrics

    expected_revenue = result[:sites].sum { |s| s[:revenue] }
    assert_equal expected_revenue, result[:totals][:revenue]
  end

  test "by_period totals match individual periods" do
    result = compute_metrics
    periods_sum = result[:totals][:by_period].sum { |p| p[:revenue] }

    assert_equal periods_sum, result[:totals][:revenue]
  end

  test "handles empty crew_sites" do
    CrewSite.delete_all

    result = compute_metrics

    assert_empty result[:sites]
    assert_equal 0, result[:totals][:revenue]
  end

  test "handles zero estimate_days" do
    @crew_site.estimate_days = 0
    @crew_site.save!

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
