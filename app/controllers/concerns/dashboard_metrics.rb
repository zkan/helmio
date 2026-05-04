module DashboardMetrics
  extend ActiveSupport::Concern

  def compute_metrics
    crew_sites = CrewSite.includes(
      crew: { crew_rate_card_items: { rate_card_item: { rate_card: :site } } },
      site: {}
    ).all

    last_12_months = (1..12).map { |i| (Date.today - i.months).strftime("%Y-%m") }.reverse

    sites_data = crew_sites.group_by(&:site).map do |site, crew_site_items|
      site_revenue = 0
      site_crew_cost = 0
      periods = []

      last_12_months.each do |month|
        month_revenue = crew_site_items.sum do |cs|
          site_rate_items = cs.crew.crew_rate_card_items.select do |crc|
            crc.rate_card_item.rate_card.site == site
          end
          (site_rate_items.sum { |crc| crc.rate_card_item.price } || 0) * cs.estimate_days.to_i
        end
        month_crew_cost = crew_site_items.sum do |cs|
          (cs.crew&.man_day_rate || 0) * cs.estimate_days.to_i
        end
        site_revenue += month_revenue
        site_crew_cost += month_crew_cost

        periods << {
          month: month,
          revenue: month_revenue,
          crew_cost: month_crew_cost,
          gross_profit: month_revenue - month_crew_cost,
          margin: month_revenue > 0 ? ((month_revenue - month_crew_cost).to_f / month_revenue * 100) : 0
        }
      end

      yearly_revenue = site_revenue * 12
      yearly_crew_cost = site_crew_cost * 12
      gross_profit = yearly_revenue - yearly_crew_cost
      margin = yearly_revenue > 0 ? (gross_profit.to_f / yearly_revenue * 100) : 0

      {
        site: site,
        revenue: site_revenue,
        crew_cost: site_crew_cost,
        gross_profit: site_revenue - site_crew_cost,
        margin: margin,
        yearly_revenue: yearly_revenue,
        yearly_crew_cost: yearly_crew_cost,
        yearly_gross_profit: gross_profit,
        yearly_margin: margin,
        periods: periods
      }
    end

    total_revenue = sites_data.sum { |s| s[:revenue] }
    total_crew_cost = sites_data.sum { |s| s[:crew_cost] }
    total_gross_profit = total_revenue - total_crew_cost
    total_margin = total_revenue > 0 ? (total_gross_profit.to_f / total_revenue * 100) : 0

    total_yearly_revenue = sites_data.sum { |s| s[:yearly_revenue] }
    total_yearly_crew_cost = sites_data.sum { |s| s[:yearly_crew_cost] }
    total_yearly_gross_profit = total_yearly_revenue - total_yearly_crew_cost
    total_yearly_margin = total_yearly_revenue > 0 ? (total_yearly_gross_profit.to_f / total_yearly_revenue * 100) : 0

    totals = {
      revenue: total_revenue,
      crew_cost: total_crew_cost,
      gross_profit: total_gross_profit,
      margin: total_margin,
      yearly_revenue: total_yearly_revenue,
      yearly_crew_cost: total_yearly_crew_cost,
      yearly_gross_profit: total_yearly_gross_profit,
      yearly_margin: total_yearly_margin,
      by_period: last_12_months.map do |month|
        idx = last_12_months.index(month)
        period_revenue = sites_data.sum { |s| s[:periods][idx][:revenue] }
        period_crew_cost = sites_data.sum { |s| s[:periods][idx][:crew_cost] }
        {
          month: month,
          revenue: period_revenue,
          crew_cost: period_crew_cost,
          gross_profit: period_revenue - period_crew_cost,
          margin: period_revenue > 0 ? ((period_revenue - period_crew_cost).to_f / period_revenue * 100) : 0
        }
      end
    }

    { sites: sites_data, totals: totals }
  end
end
