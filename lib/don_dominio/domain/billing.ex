defmodule DonDominio.Domain.Billing do
  @moduledoc """
  The total price charged (in `currency`) for a `domain/create`,
  `domain/transfer`, or `domain/renew` action, embedded alongside
  `DonDominio.Domain.Create`'s or `DonDominio.Domain.Renew`'s response.
  """
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:total, :decimal)
    field(:currency, :string)
  end
end
