defmodule DonDominio.Domain.Info do
  @moduledoc """
  Full details of a registered domain, as returned by
  `DonDominio.Domain.info/2`. Which optional fields are populated depends on
  the `type` requested (`:status`, `:contact`, `:nameservers`, `:authcode`,
  ... -- omitting `type` returns everything).
  """
  use DonDominio.Schema
  alias DonDominio.Domain.Status

  @renewal_modes ~w[
    autorenew
    manual
    letexpire
  ]a

  @primary_key false
  typed_embedded_schema do
    field(:name, :string)
    field(:status, Ecto.Enum, values: Status.statuses())
    field(:tld, :string)
    field(:tsExpir, :date)
    field(:domainID, :integer)

    # status type
    field(:tsCreate, :date)
    field(:renewable, :boolean)
    field(:renewalMode, Ecto.Enum, values: @renewal_modes)
    field(:modifyBlock, :boolean)
    field(:transferBlock, :boolean)
    field(:whoisPrivacy, :boolean)
    field(:viewWhois, :boolean)
    field(:authcodeCheck, :boolean)
    field(:serviceAssociated, :boolean)
    field(:tag, :string)
    # TODO
    field(:ownerverification, :string)
    # TODO
    field(:transferStatus, :string)

    # contact type
    #  TODO
    field(:contactOwner, :map)
    #  TODO
    field(:contactAdmin, :map)
    #  TODO
    field(:contactTech, :map)
    #  TODO
    field(:contactBilling, :map)

    # nameservers type
    field(:defaultNS, :boolean)

    embeds_many :nameservers, Nameservers, primary_key: false do
      @moduledoc """
      One of a domain's name servers, as embedded in `DonDominio.Domain.Info`.
      """
      field(:order, :integer)
      field(:name, :string)
      field(:ipv4, :string)
      field(:ipv6, :string)
    end

    # authcode type
    field(:authcode, :string)

    # TODO service
    #  TODO glue records
    #  TODO dnssec
  end
end
