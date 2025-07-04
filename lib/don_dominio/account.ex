defmodule DonDominio.Account do
  use DonDominio.Request
  alias DonDominio.Account.ZoneCache

  def info do
    request("/account/info/")
  end

  def promos do
    request("/account/promos/")
  end

  def zones(options \\ %{page: 1, pageLength: 100}) do
    request(options, "/account/zones/")
  end

  def get_zone_by_tld(tld) do
    GenServer.call(ZoneCache, {:get_zone_by_tld, tld})
  end

  def get_zones_by_top_tld(tld) do
    GenServer.call(ZoneCache, {:get_zones_by_top_tld, tld})
  end
end
