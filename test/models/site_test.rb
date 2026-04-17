require "test_helper"

class SiteTest < ActiveSupport::TestCase
  test "should be valid with required attributes" do
    site = Site.new(name: "Test Site", is_active: true)
    assert site.valid?
  end

  test "should allow site without name" do
    site = Site.new(is_active: true)
    assert site.valid?
  end

  test "should filter active sites" do
    active = Site.create!(name: "Active", is_active: true)
    inactive = Site.create!(name: "Inactive", is_active: false)

    assert_includes Site.where(is_active: true), active
    assert_not_includes Site.where(is_active: true), inactive
  end
end
