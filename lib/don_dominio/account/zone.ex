defmodule DonDominio.Account.Zone do
  @moduledoc """
  A TLD available for registration on the reseller account, as returned by
  `DonDominio.Account.zones/1` -- `tldtop` groups related TLDs together
  (e.g. `"es"` and `"com.es"` share `tldtop: "es"`, see
  `DonDominio.Account.get_zones_by_top_tld/1`), and `create`/`renew`/`transfer`
  each carry that action's `DonDominio.Account.ZonePrice`.
  """
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
