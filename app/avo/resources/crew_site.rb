class Avo::Resources::CrewSite < Avo::BaseResource
  def fields
    field :id, as: :id
    field :crew, as: :belongs_to
    field :site, as: :belongs_to
    field :estimate_days, as: :number
  end
end
