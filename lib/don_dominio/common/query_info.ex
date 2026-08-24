defmodule DonDominio.Common.QueryInfo do
  @moduledoc """
  Pagination metadata attached to list-style API responses (e.g.
  `DonDominio.Account.zones/1`, `DonDominio.Contact.list/1`): the requested
  `page`/`pageLength`, how many `results` this page contains, and the `total`
  across all pages.
  """
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:page, :integer)
    field(:pageLength, :integer)
    field(:results, :integer)
    field(:total, :integer)
  end
end
