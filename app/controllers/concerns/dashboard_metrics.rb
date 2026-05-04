module DashboardMetrics
  extend ActiveSupport::Concern

  def compute_metrics
    crew_sites = CrewSite.includes(
      crew: { crew_rate_card_items: { rate_card_item: { rate_card: :site } } },
      site: {}
    ).all

    sites_data = crew_sites.group_by(&:site).map do |site, crew_site_items|
      calculate_site_metrics(site, crew_site_items)
    end

    totals = calculate_totals(sites_data)

    { sites: sites_data, totals: totals }
  end

  private

  def calculate_site_metrics(site, crew_site_items)
    revenue = crew_site_items.sum { |cs| site_revenue(cs, site) }
    delivery_cost = crew_site_items.sum { |cs| crew_delivery_cost(cs) }
    gross_profit = revenue - delivery_cost

    {
      site: site,
      crew_sites: crew_site_items.uniq { |cs| cs.crew_id },
      revenue: revenue,
      delivery_cost: delivery_cost,
      gross_profit: gross_profit,
      margin: calculate_margin(revenue, gross_profit)
    }
  end

  def calculate_totals(sites_data)
    revenue = sites_data.sum { |s| s[:revenue] }
    delivery_cost = sites_data.sum { |s| s[:delivery_cost] }
    gross_profit = revenue - delivery_cost

    {
      revenue: revenue,
      delivery_cost: delivery_cost,
      gross_profit: gross_profit,
      margin: calculate_margin(revenue, gross_profit)
    }
  end

  def site_revenue(crew_site, site)
    site_rate_items = crew_site.crew.crew_rate_card_items.select do |crc|
      crc.rate_card_item.rate_card.site == site
    end
    (site_rate_items.sum { |crc| crc.rate_card_item.price } || 0) * crew_site.estimate_days.to_i
  end

  def crew_delivery_cost(crew_site)
    (crew_site.crew&.man_day_rate || 0) * crew_site.estimate_days.to_i
  end

  def calculate_margin(revenue, gross_profit)
    revenue > 0 ? (gross_profit.to_f / revenue * 100) : 0
  end
end
