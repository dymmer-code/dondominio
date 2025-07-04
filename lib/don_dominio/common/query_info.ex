defmodule DonDominio.Common.QueryInfo do
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:page, :integer)
    field(:pageLength, :integer)
    field(:results, :integer)
    field(:total, :integer)
  end
end
