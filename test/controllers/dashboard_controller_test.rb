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
    assert_select "p", /Monthly Gross Profit/
  end

  test "should display total revenue" do
    get dashboard_url
    assert_select "p", /Monthly Revenue/
  end

  test "should display total margin" do
    get dashboard_url
    assert_select "p", /Monthly Margin/
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

  test "should display crew toggle button" do
    get dashboard_url
    assert_select "button", /Show crews/
  end

  test "should display crew name in toggle" do
    get dashboard_url
    assert_select "tbody td", /John Doe/
  end

  test "should display crew man day rate" do
    get dashboard_url
    assert_select "tbody td", /1,500/
  end

  test "should display crew rate card item" do
    get dashboard_url
    assert_match(/THB/, response.body)
  end

  test "should display crew information in table format" do
    get dashboard_url
    assert_select "table" do
      assert_select "th", /Crew/
      assert_select "th", /Man Day Rate/
      assert_select "th", /Rate Card Price/
      assert_select "th", /Estimate Days/
    end
  end

  test "should display estimate days value for each crew" do
    get dashboard_url
    assert_select "tbody td", /20/
  end

  test "should sort crews by man day rate descending" do
    get dashboard_url
    html = response.body
    jane_idx = html.index("Jane Smith")
    john_idx = html.index("John Doe")
    assert jane_idx < john_idx, "Expected Jane Smith (1800) to appear before John Doe (1500)"
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
