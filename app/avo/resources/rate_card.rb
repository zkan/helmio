class Avo::Resources::RateCard < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :site, as: :belongs_to
    field :effective_from, as: :date
    field :effective_to, as: :date
  end
end
