class Avo::Resources::Crew < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :name_th, as: :text
    field :nickname, as: :text
    field :email, as: :text
    field :phone, as: :text
    field :man_day_rate, as: :number
    field :joined_date, as: :date
    field :site, as: :belongs_to, optional: true
  end
end
