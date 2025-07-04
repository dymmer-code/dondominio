defmodule DonDominio.Account.Zone do
  use DonDominio.Schema
  alias DonDominio.Account.ZonePrice

  @primary_key false
  typed_embedded_schema do
    field(:tld, :string)
    field(:tldtop, :string)
    field(:authcodereq, :boolean)
    field(:requirements, {:array, :string})
    embeds_one(:create, ZonePrice)
    embeds_one(:renew, ZonePrice)
    embeds_one(:transfer, ZonePrice)
  end
end
