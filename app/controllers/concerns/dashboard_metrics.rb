module DashboardMetrics
  extend ActiveSupport::Concern

  def compute_metrics
    crew_sites = CrewSite.includes(
      crew: { crew_rate_card_items: { rate_card_item: { rate_card: :site } } },
      site: {}
    ).all

    sites_data = crew_sites.group_by(&:site).map do |site, crew_site_items|
      month_revenue = crew_site_items.sum do |cs|
        site_rate_items = cs.crew.crew_rate_card_items.select do |crc|
          crc.rate_card_item.rate_card.site == site
        end
        (site_rate_items.sum { |crc| crc.rate_card_item.price } || 0) * cs.estimate_days.to_i
      end
      month_crew_cost = crew_site_items.sum do |cs|
        (cs.crew&.man_day_rate || 0) * cs.estimate_days.to_i
      end
      gross_profit = month_revenue - month_crew_cost
      margin = month_revenue > 0 ? (gross_profit.to_f / month_revenue * 100) : 0
      yearly_revenue = month_revenue * 12
      yearly_crew_cost = month_crew_cost * 12
      yearly_gross_profit = yearly_revenue - yearly_crew_cost
      yearly_margin = yearly_revenue > 0 ? (yearly_gross_profit.to_f / yearly_revenue * 100) : 0

      {
        site: site,
        crew_sites: crew_site_items.uniq { |cs| cs.crew_id },
        revenue: month_revenue,
        crew_cost: month_crew_cost,
        gross_profit: gross_profit,
        margin: margin,
        yearly_revenue: yearly_revenue,
        yearly_crew_cost: yearly_crew_cost,
        yearly_gross_profit: yearly_gross_profit,
        yearly_margin: yearly_margin
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
      yearly_margin: total_yearly_margin
    }

    { sites: sites_data, totals: totals }
  end
end
