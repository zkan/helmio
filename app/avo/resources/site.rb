class Avo::Resources::Site < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :company_address, as: :textarea
    field :company_name, as: :text
    field :company_tax_id, as: :text
    field :description, as: :textarea
    field :active, as: :boolean
    field :name, as: :text
  end
end
