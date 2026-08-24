defmodule DonDominio.Account.ZonePrice do
  @moduledoc """
  The price for one domain action (create/renew/transfer) on a
  `DonDominio.Account.Zone`, valid for the given `years` range, and whether
  it's currently discounted by a promotion (`inPromo`).
  """
  use DonDominio.Schema
  alias DonDominio.Schema.Range

  @primary_key false
  typed_embedded_schema do
    field(:price, :decimal)
    field(:years, Range)
    field(:inPromo, :boolean, default: false)
  end
end
