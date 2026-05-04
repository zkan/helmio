require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site = sites(:active_site)
    @crew = crews(:one)
    @rate_card = rate_cards(:one)
  end

  test "should get index" do
    get dashboard_url
    assert_response :success
  end

  test "should display gross profit" do
    get dashboard_url
    assert_select "p", /Gross Profit/
  end

  test "should display revenue" do
    get dashboard_url
    assert_select "p", /Revenue/
  end

test "should display margin" do
    get dashboard_url
    assert_select "p", /Margin/
  end

  test "should display total gross profit" do
    get dashboard_url
    assert_select "p", /Total Gross Profit/
  end

  test "should display total revenue" do
    get dashboard_url
    assert_select "p", /Total Revenue/
  end

  test "should display total margin" do
    get dashboard_url
    assert_select "p", /Total Margin/
  end

  test "should display THB currency" do
    get dashboard_url
    assert_select ".text-green-600"
    assert_select ".text-blue-600"
  end

  test "should display THB text for gross profit" do
    get dashboard_url
    assert_response :success
    assert_match /THB/, response.body
  end

  test "should display by site section" do
    get dashboard_url
    assert_select "h2", /By Site/
  end

  test "should display site name in breakdown" do
    get dashboard_url
    assert_select "h3"
  end

  test "should have cards for site breakdown" do
    get dashboard_url
    assert_select ".grid.grid-cols-1.gap-6"
  end

  test "should display dashboard link in sidebar" do
    get dashboard_url
    assert_select "aside"
    assert_select "aside a[href=?]", dashboard_path
    assert_select "aside a", /Dashboard/
  end
end
