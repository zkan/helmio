require "test_helper"

class SiteTest < ActiveSupport::TestCase
  test "should be valid with required attributes" do
    site = Site.new(name: "Test Site", active: true)
    assert site.valid?
  end

  test "should allow site without name" do
    site = Site.new(active: true)
    assert site.valid?
  end

  test "should filter active sites" do
    active = Site.create!(name: "Active", active: true)
    inactive = Site.create!(name: "Inactive", active: false)

    assert_includes Site.where(active: true), active
    assert_not_includes Site.where(active: true), inactive
  end
end
