defmodule DonDominio.Account.Promo do
  @moduledoc """
  A promotional price for a domain/SSL `action` (create or transfer),
  as returned by `DonDominio.Account.promos/0` -- `price` applies to the
  matching `tld`/`productID` while the current time falls within
  `tsIni`..`tsEnd`.
  """
  use DonDominio.Schema

  # TODO it's possible we will need more values here
  @promo_types ~w[domain ssl]a

  # TODO it's possible we will need more values here
  @actions ~w[create transfer]a

  @primary_key false
  typed_embedded_schema do
    field(:promo, :string)
    field(:type, Ecto.Enum, values: @promo_types)
    field(:action, Ecto.Enum, values: @actions)
    field(:price, :decimal)
    field(:tsIni, :naive_datetime)
    field(:tsEnd, :naive_datetime)
    field(:tld, :string)
    field(:productID, :integer)
  end
end
