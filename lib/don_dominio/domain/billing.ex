defmodule DonDominio.Domain.Billing do
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:total, :decimal)
    field(:currency, :string)
  end
end
