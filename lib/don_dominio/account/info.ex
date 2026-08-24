defmodule DonDominio.Account.Info do
  @moduledoc """
  The reseller account's own information, as returned by
  `DonDominio.Account.info/0`: name, API user, prepaid balance/threshold
  (in `currency`), and the IP the request was made from.
  """
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
