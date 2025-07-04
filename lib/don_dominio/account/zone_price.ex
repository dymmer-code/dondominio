defmodule DonDominio.Account.ZonePrice do
  use DonDominio.Schema
  alias DonDominio.Schema.Range

  @primary_key false
  typed_embedded_schema do
    field(:price, :decimal)
    field(:years, Range)
    field(:inPromo, :boolean, default: false)
  end
end
