class Avo::Resources::CrewRateCardItem < Avo::BaseResource
  def fields
    field :id, as: :id
    field :crew, as: :belongs_to
    field :rate_card_item, as: :belongs_to
  end
end
