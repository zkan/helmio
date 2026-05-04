class AddEstimateDaysToCrewSites < ActiveRecord::Migration[8.1]
  def change
    add_column :crew_sites, :estimate_days, :integer
  end
end
