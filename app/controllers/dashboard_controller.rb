class DashboardController < ApplicationController
  include DashboardMetrics

  def index
    metrics = compute_metrics

    @sites = metrics[:sites]
    @total_revenue = metrics[:totals][:revenue]
    @total_crew_cost = metrics[:totals][:crew_cost]
    @total_gross_profit = metrics[:totals][:gross_profit]
    @total_margin = metrics[:totals][:margin]
  end
end
