class SitesController < ApplicationController
  def index
    @sites = Site.where(is_active: true)
  end
end
