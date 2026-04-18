class SitesController < ApplicationController
  def index
    @sites = Site.where(active: true)
  end
end
