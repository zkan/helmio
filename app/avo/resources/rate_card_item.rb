class Avo::Resources::RateCardItem < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :rate_card, as: :belongs_to
    field :role, as: :text
    field :unit, as: :text
    field :price, as: :number
    field :currency, as: :text
  end
end
