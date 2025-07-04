defmodule DonDominio.Contact.Info do
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
