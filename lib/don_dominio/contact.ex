defmodule DonDominio.Contact do
  use DonDominio.Request
  alias DonDominio.Response

  @type contact_individual_map() :: %{
          required(:FirstName) => String.t(),
          required(:LastName) => String.t(),
          required(:IdentNumber) => String.t(),
          required(:Email) => String.t(),
          required(:Phone) => String.t(),
          required(:Address) => String.t(),
          required(:PostalCode) => String.t(),
          required(:City) => String.t(),
          required(:State) => String.t(),
          required(:Country) => String.t()
        }

  @spec create_individual(contact_individual_map()) :: {:ok, Response.t()} | {:error, any()}
  def create_individual(contact) do
    contact
    |> Map.take(
      ~w(FirstName LastName IdentNumber Email Phone Address PostalCode City State Country)a
    )
    |> Map.put(:Type, :individual)
    |> request("/contact/create/")
  end

  @type contact_organization_map() :: %{
          required(:FirstName) => String.t(),
          required(:LastName) => String.t(),
          required(:OrgName) => String.t(),
          required(:IdentNumber) => String.t(),
          required(:Email) => String.t(),
          required(:Phone) => String.t(),
          required(:Address) => String.t(),
          required(:PostalCode) => String.t(),
          required(:City) => String.t(),
          required(:State) => String.t(),
          required(:Country) => String.t()
        }

  @spec create_organization(contact_organization_map()) :: {:ok, Response.t()} | {:error, any()}
  def create_organization(contact) do
    contact
    |> Map.take(
      ~w(FirstName LastName OrgName IdentNumber Email Phone Address PostalCode City State Country)a
    )
    |> Map.put(:Type, :organization)
    |> request("/contact/create/")
  end

  @type filter_options() :: %{
          optional(:pageLength) => pos_integer(),
          optional(:page) => pos_integer(),
          optional(:name) => String.t(),
          optional(:email) => String.t(),
          optional(:country) => String.t(),
          optional(:identNumber) => String.t(),
          optional(:verificationstatus) => String.t(),
          optional(:daaccepted) => boolean()
        }

  @spec list() :: {:ok, Response.t()} | {:error, any()}
  @spec list(filter_options()) :: {:ok, Response.t()} | {:error, any()}
  def list(options \\ %{}) do
    request(options, "contact/list/")
  end

  @type contact_id() :: String.t()

  @spec info(contact_id()) :: {:ok, Response.t()} | {:error, any}
  def info(contact_id) do
    # XXX: at the moment there are no another infoType available
    request(%{contactID: contact_id, infoType: "data"}, "/contact/getinfo/")
  end
end
