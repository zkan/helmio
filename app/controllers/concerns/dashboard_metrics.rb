module DashboardMetrics
  extend ActiveSupport::Concern

  def compute_metrics
    crew_rate_card_items = CrewRateCardItem.includes(crew: {}, rate_card_item: { rate_card: :site }).all

    grouped = crew_rate_card_items.group_by { |crc| crc.rate_card_item.rate_card.site }

    sites = grouped.map do |site, items|
      revenue = items.sum { |crc| crc.rate_card_item.price }
      crew_cost = items.sum { |crc| crc.crew.man_day_rate || 0 }
      gross_profit = revenue - crew_cost
      margin = revenue > 0 ? (gross_profit.to_f / revenue * 100) : 0

      {
        site: site,
        revenue: revenue,
        crew_cost: crew_cost,
        gross_profit: gross_profit,
        margin: margin
      }
    end

    total_revenue = sites.sum { |s| s[:revenue] }
    total_crew_cost = sites.sum { |s| s[:crew_cost] }
    total_gross_profit = total_revenue - total_crew_cost
    total_margin = total_revenue > 0 ? (total_gross_profit.to_f / total_revenue * 100) : 0

    {
      sites: sites,
      totals: {
        revenue: total_revenue,
        crew_cost: total_crew_cost,
        gross_profit: total_gross_profit,
        margin: total_margin
      }
    }
  end
end
