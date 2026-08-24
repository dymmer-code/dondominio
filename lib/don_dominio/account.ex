defmodule DonDominio.Account do
  @moduledoc """
  Reseller account-level information: balance/details, active promotions,
  and the DNS zones available for the reseller's account.
  """
  use DonDominio.Request
  alias DonDominio.Account.ZoneCache

  @doc """
  Fetches the reseller account's own information (balance, contact data, ...).
  """
  def info do
    request("/account/info/")
  end

  @doc """
  Lists the promotions currently active for the reseller account.
  """
  def promos do
    request("/account/promos/")
  end

  @doc """
  Lists the DNS zones available for the reseller account, paginated.
  """
  def zones(options \\ %{page: 1, pageLength: 100}) do
    request(options, "/account/zones/")
  end

  @doc """
  Looks up a cached zone by its exact TLD, via `DonDominio.Account.ZoneCache`.
  """
  def get_zone_by_tld(tld) do
    GenServer.call(ZoneCache, {:get_zone_by_tld, tld})
  end

  @doc """
  Looks up cached zones sharing the given top-level TLD grouping (e.g. `"es"`
  also returns `"com.es"`, `"org.es"`, ...), via `DonDominio.Account.ZoneCache`.
  """
  def get_zones_by_top_tld(tld) do
    GenServer.call(ZoneCache, {:get_zones_by_top_tld, tld})
  end
end
