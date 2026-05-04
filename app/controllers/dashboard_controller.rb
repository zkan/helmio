class DashboardController < ApplicationController
  include DashboardMetrics

  def index
    metrics = compute_metrics

    @sites = metrics[:sites]
    @totals = metrics[:totals]
  end
end
