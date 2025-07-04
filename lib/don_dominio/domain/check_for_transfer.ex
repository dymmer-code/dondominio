defmodule DonDominio.Domain.CheckForTransfer do
  @moduledoc """
  The check data structure is giving us the information about the result of
  checking a domain name. See `t/0`.
  """
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:name, :string)
    field(:punycode, :string)
    field(:tld, :string)
    field(:transferavail, :boolean)
    field(:transfermsg, {:array, :string})
    field(:price, :decimal)
    field(:currency, :string)
  end
end
