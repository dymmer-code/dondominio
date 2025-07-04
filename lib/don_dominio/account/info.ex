defmodule DonDominio.Account.Info do
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:clientName, :string)
    field(:apiuser, :string)
    field(:balance, :decimal)
    field(:threshold, :decimal)
    field(:currency, :string)
    field(:ip, :string)
  end
end
