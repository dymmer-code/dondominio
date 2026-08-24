defmodule DonDominio.Contact.Info do
  @moduledoc """
  A registrant/admin/tech/billing contact, as returned by
  `DonDominio.Contact.info/1` and `DonDominio.Contact.list/1` -- either an
  `:individual` (`firstName`/`lastName`) or an `:organization` (`orgName`),
  per `contactType`.
  """
  use DonDominio.Schema

  @primary_key false
  typed_embedded_schema do
    field(:contactID, :string)
    field(:contactType, Ecto.Enum, values: [:individual, :organization])
    field(:contactName, :string)
    field(:firstName, :string)
    field(:lastName, :string)
    field(:orgName, :string)
    field(:identNumber, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:address, :string)
    field(:postalCode, :string)
    field(:city, :string)
    field(:state, :string)
    field(:country, :string)
    field(:verificationstatus, :string)
    field(:daaccepted, :boolean)
  end
end
