defmodule DonDominio.Domain do
  @moduledoc """
  The `DonDominio.Domain` module is responsible for interacting with the
  DonDominio API to check the status of a domain, register a domain,
  transfer a domain, delete a domain, and retrieve the price of a domain.
  """
  use DonDominio.Request
  alias DonDominio.Domain.Status
  alias DonDominio.Response

  @doc """
  Check if a domain is available for registration.
  """
  def check(domain) do
    request(%{domain: domain}, "/domain/check/")
  end

  def check_for_transfer(domain) do
    request(%{domain: domain}, "/domain/checkfortransfer/")
  end

  @type domain() :: String.t()
  @type domain_id() :: pos_integer()
  @type period() :: 1..10
  @type nameservers() :: [String.t()]
  @type contact_id() :: String.t()
  @type contact_ids() :: %{
          owner_id: contact_id(),
          admin_id: contact_id(),
          tech_id: contact_id(),
          billing_id: contact_id()
        }
  @type additional() :: %{}
  @type premium() :: boolean()

  @spec create(domain(), period(), nameservers(), contact_ids()) ::
          {:ok, Response.t()} | {:error, any()}
  @spec create(domain(), period(), nameservers(), contact_ids(), additional()) ::
          {:ok, Response.t()} | {:error, any()}
  @spec create(domain(), period(), nameservers(), contact_ids(), additional(), premium()) ::
          {:ok, Response.t()} | {:error, any()}
  def create(domain, period, ns, contacts, additional \\ %{}, premium \\ false)
      when is_binary(domain) and is_integer(period) do
    %{
      domain: domain,
      period: period,
      premium: premium,
      nameservers: Enum.join(ns, ","),
      ownerContactID: contacts.owner_id,
      adminContactID: contacts.admin_id,
      techContactID: contacts.tech_id,
      billingContactID: contacts.billing_id
    }
    |> add_if_in([:aero], additional, [:aeroId, :aeroPass])
    |> add_if_in(
      ~w[barcelona madrid cat scot eus gal quebec radio]a,
      additional,
      [:domainIntendedUse]
    )
    |> add_if_in(~w[ee fi hk moscow my ru vn]a, additional, [:ownerDateOfBirth])
    |> add_if_in(~w[fr re yt pm wf tf]a, additional, [:frTradeMark, :frSirenNumber])
    |> add_if_in([:ru], additional, [:ruIssuer, :ruIssuerDate])
    |> add_if_in([:xxx], additional, [:xxxClass, :xxxName, :xxxEmail, :xxxId])
    |> request("/domain/create/")
  end

  defp add_if_in(data, tlds, additional, keys) do
    tld = String.split(data.domain, ".") |> List.last()

    if tld in tlds do
      Map.merge(data, Map.take(additional, keys))
    else
      data
    end
  end

  @type auth_code() :: String.t()

  @spec create(domain(), auth_code(), nameservers(), contact_ids()) ::
          {:ok, Response.t()} | {:error, any()}
  @spec create(domain(), auth_code(), nameservers(), contact_ids(), additional()) ::
          {:ok, Response.t()} | {:error, any()}
  def transfer(domain, auth_code, ns, contacts, additional \\ %{}) when is_binary(domain) do
    %{
      domain: domain,
      authcode: auth_code,
      nameservers: Enum.join(ns, ","),
      ownerContactID: contacts.owner_id,
      adminContactID: contacts.admin_id,
      techContactID: contacts.tech_id,
      billingContactID: contacts.billing_id
    }
    |> add_if_in([:jobs], additional, ~w[
      jobsOwnerIsAssocMember
      jobsOwnerWebsite
      jobsOwnerTitle
      jobsOwnerIndustrytype
      jobsAdminIsAssocMember
      jobsAdminWebsite
      jobsAdminTitle
      jobsAdminIndustrytype
      jobsTechIsAssocMember
      jobsTechWebsite
      jobsTechTitle
      jobsTechIndustrytype
      jobsBillingIsAssocMember
      jobsBillingWebsite
      jobsBillingTitle
      jobsBillingIndustrytype
    ]a)
    |> add_if_in(~w[ee fi hk moscow my ru vn]a, additional, [:ownerDateOfBirth])
    |> add_if_in([:ru], additional, [:ruIssuer, :ruIssuerDate])
    |> request("/domain/transfer/")
  end

  @spec transfer_restart(domain() | domain_id(), auth_code()) ::
          {:ok, Response.t()} | {:error, any()}
  def transfer_restart(domain, auth_code) when is_binary(domain) do
    %{
      domain: domain,
      authcode: auth_code
    }
    |> request("/domain/transferrestart/")
  end

  def transfer_restart(domain_id, auth_code) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      authcode: auth_code
    }
    |> request("/domain/transferrestart/")
  end

  @spec update_contact(domain() | domain_id(), contact_ids()) ::
          {:ok, Response.t()} | {:error, any()}
  def update_contact(domain, contacts) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "contact",
      ownerContactID: contacts.owner_id,
      adminContactID: contacts.admin_id,
      techContactID: contacts.tech_id,
      billingContactID: contacts.billing_id
    }
    |> request("/domain/update/")
  end

  def update_contact(domain_id, contacts) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      updateType: "contact",
      ownerContactID: contacts.owner_id,
      adminContactID: contacts.admin_id,
      techContactID: contacts.tech_id,
      billingContactID: contacts.billing_id
    }
    |> request("/domain/update/")
  end

  @spec update_nameservers(domain() | domain_id(), nameservers()) ::
          {:ok, Response.t()} | {:error, any()}
  def update_nameservers(domain, ns) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "nameservers",
      nameservers: Enum.join(ns, ",")
    }
    |> request("/domain/update/")
  end

  def update_nameservers(domain_id, ns) when is_binary(domain_id) do
    %{
      domainID: domain_id,
      updateType: "nameservers",
      nameservers: Enum.join(ns, ",")
    }
    |> request("/domain/update/")
  end

  @spec update_transfer_block(domain() | domain_id(), boolean()) ::
          {:ok, Response.t()} | {:error, any()}
  def update_transfer_block(domain, block) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "transferBlock",
      transferBlock: block
    }
    |> request("/domain/update/")
  end

  def update_transfer_block(domain_id, block) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      updateType: "transferBlock",
      transferBlock: block
    }
    |> request("/domain/update/")
  end

  @spec update_block(domain() | domain_id(), boolean()) :: {:ok, Response.t()} | {:error, any()}
  def update_block(domain, block) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "block",
      block: block
    }
    |> request("/domain/update/")
  end

  def update_block(domain_id, block) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      updateType: "block",
      block: block
    }
    |> request("/domain/update/")
  end

  @spec update_whois_privacy(domain() | domain_id(), boolean()) ::
          {:ok, Response.t()} | {:error, any()}
  def update_whois_privacy(domain, view_whois) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "viewWhois",
      viewWhois: view_whois
    }
    |> request("/domain/update/")
  end

  def update_whois_privacy(domain_id, view_whois) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      updateType: "viewWhois",
      viewWhois: view_whois
    }
    |> request("/domain/update/")
  end

  @type renewal_mode() :: :autorenew | :manual

  @spec update_renewal_mode(domain() | domain_id(), renewal_mode()) ::
          {:ok, Response.t()} | {:error, any()}
  def update_renewal_mode(domain, renewal_mode) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "renewalMode",
      renewalMode: to_string(renewal_mode)
    }
    |> request("/domain/update/")
  end

  def update_renewal_mode(domain_id, renewal_mode) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      updateType: "renewalMode",
      renewalMode: to_string(renewal_mode)
    }
    |> request("/domain/update/")
  end

  @type tags() :: [String.t()]

  @spec update_tag(domain() | domain_id(), tags()) :: {:ok, Response.t()} | {:error, any()}
  def update_tag(domain, tags) when is_binary(domain) do
    %{
      domain: domain,
      updateType: "tag",
      tag: Enum.join(tags, ",")
    }
    |> request("/domain/update/")
  end

  def update_tag(domain_id, tag) when is_integer(domain_id) do
    %{
      domainID: domain_id,
      updateType: "tag",
      tag: Enum.join(tag, ",")
    }
    |> request("/domain/update/")
  end

  # TODO GlueRecord Create
  # TODO GlueRecord Update
  # TODO GlueRecord Delete

  @type info_type() ::
          :status | :contact | :nameservers | :authcode | :service | :gluerecords | :dnssec

  @type filter_options() :: %{
          optional(:pageLength) => pos_integer(),
          optional(:page) => pos_integer(),
          optional(:domain) => String.t(),
          optional(:word) => String.t(),
          optional(:tld) => String.t(),
          optional(:renewable) => boolean(),
          optional(:infoType) => info_type(),
          optional(:owner) => contact_id(),
          optional(:tag) => String.t(),
          optional(:status) => Status.status_code(),
          #  TODO contact and status for verification
          optional(:ownerverification) => String.t(),
          optional(:renewalMode) => :autorenew | :manual | :letexpire
        }

  @spec list() :: {:ok, Response.t()} | {:error, any()}
  @spec list(filter_options()) :: {:ok, Response.t()} | {:error, any()}
  def list(options \\ %{}) do
    request(options, "/domain/list/")
  end

  @spec info(domain() | domain_id()) :: {:ok, Response.t()} | {:error, any()}
  @spec info(domain() | domain_id(), nil | info_type()) :: {:ok, Response.t()} | {:error, any()}
  def info(domain, type \\ nil)

  def info(domain, type) when is_binary(domain) do
    %{domain: domain}
    |> maybe_add(:type, type)
    |> request("/domain/getinfo/")
  end

  def info(domain_id, type) when is_integer(domain_id) do
    %{domainID: domain_id}
    |> maybe_add(:type, type)
    |> request("/domain/getinfo/")
  end

  @type expiration_date() :: Date.t()

  @spec renew(domain() | domain_id(), expiration_date(), period()) ::
          {:ok, Response.t()} | {:error, any()}
  def renew(domain, expiration_date, period) when is_binary(domain) do
    %{domain: domain, curExpDate: expiration_date, period: period}
    |> request("/domain/renew/")
  end

  def renew(domain_id, expiration_date, period) when is_integer(domain_id) do
    %{domainID: domain_id, curExpDate: expiration_date, period: period}
    |> request("/domain/renew/")
  end

  @spec whois(domain()) :: {:ok, Response.t()} | {:error, any()}
  def whois(domain) when is_binary(domain) do
    request(%{domain: domain}, "/domain/whois/")
  end
end
