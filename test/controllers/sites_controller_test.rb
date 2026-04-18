require "test_helper"

class SitesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should only show active sites" do
    get root_url
    assert_select "h2", "Active Corp"
    assert_select "h2", { count: 0, text: "Inactive Corp" }
  end

  test "should display site details" do
    get root_url
    assert_select "p", /Active Corporation/
    assert_select "p", /123 Active St/
    assert_select "p", /12-3456789/
  end

  test "should show empty state when no active sites" do
    Site.where(is_active: true).destroy_all
    get root_url
    assert_select "p", /No active sites found/
  end

  test "should display sidebar with sites link" do
    get root_url
    assert_select "aside"
    assert_select "aside a[href=?]", sites_path
    assert_select "aside a", /Sites/
  end
end
