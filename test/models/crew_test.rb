require "test_helper"

class CrewTest < ActiveSupport::TestCase
  setup do
    @site = sites(:active_site)
    @crew = crews(:one)
  end

  test "should be valid with required attributes" do
    assert @crew.valid?
  end

  test "should have sites through crew_sites" do
    assert_includes @crew.sites, @site
  end

  test "should have name" do
    assert_equal "John Doe", @crew.name
  end

  test "should have name_th" do
    assert_equal "จอห์น โด", @crew.name_th
  end

  test "should have nickname" do
    assert_equal "Johnny", @crew.nickname
  end

  test "should have email" do
    assert_equal "john@example.com", @crew.email
  end

  test "should have phone" do
    assert_equal "1234567890", @crew.phone
  end

  test "should have man_day_rate" do
    assert_equal 1500.00, @crew.man_day_rate
  end

  test "should have joined_date" do
    assert_equal Date.new(2026, 1, 15), @crew.joined_date
  end

  test "should have billable" do
    assert_equal true, @crew.billable
  end

  test "should have non_billable crew" do
    assert_equal false, crews(:two).billable
  end
end
