defmodule DonDominio.Domain.Renew do
  use DonDominio.Schema
  import DonDominio.Domain.Status, only: [statuses: 0]

  @primary_key false
  typed_embedded_schema do
    field(:name, :string)
    field(:status, Ecto.Enum, values: statuses())
    field(:tld, :string)
    field(:tsExpir, :date)
    field(:domainID, :integer)
    field(:renewPeriod, :integer)
    field(:inPromo, :boolean, default: false)
  end

  def normalize(params) when not is_struct(params) and is_map(params) do
    params =
      params
      |> change_if("tsExpir", "", nil)

    Ecto.embedded_load(__MODULE__, params, :json)
  end
end
