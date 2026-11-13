defmodule DonDominio.Account.Zone do
  @moduledoc """
  A TLD available for registration on the reseller account, as returned by
  `DonDominio.Account.zones/1` -- `tldtop` groups related TLDs together
  (e.g. `"es"` and `"com.es"` share `tldtop: "es"`, see
  `DonDominio.Account.get_zones_by_top_tld/1`), and `create`/`renew`/`transfer`
  each carry that action's `DonDominio.Account.ZonePrice`.
  """
  use DonDominio.Schema
  alias DonDominio.Account.ZonePrice

  @primary_key false
  typed_embedded_schema do
    field(:tld, :string)
    field(:tldtop, :string)
    field(:authcodereq, :boolean)
    field(:requirements, {:array, :string})
    embeds_one(:create, ZonePrice)
    embeds_one(:renew, ZonePrice)
    embeds_one(:transfer, ZonePrice)
  end

  @doc """
  Builds the zone from the API's JSON.

  The API sends `requirements` as a list of texts for most TLDs, but for some
  (`.aero` since November 2026) as one HTML text: it becomes a list with that
  text, and an empty text becomes an empty list, so that a change of shape in
  one TLD never prevents the rest from loading.
  """
  def normalize(%{"requirements" => requirements} = params) do
    params
    |> Map.put("requirements", requirements(requirements))
    |> then(&Ecto.embedded_load(__MODULE__, &1, :json))
  end

  def normalize(params), do: Ecto.embedded_load(__MODULE__, params, :json)

  defp requirements(list) when is_list(list), do: Enum.map(list, &to_string/1)

  defp requirements(text) when is_binary(text) do
    if String.trim(text) == "", do: [], else: [text]
  end

  defp requirements(other), do: other
end
