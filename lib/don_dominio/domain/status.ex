defmodule DonDominio.Domain.Status do
  @moduledoc """
  A domain's current status, as returned by `DonDominio.Domain.check/1`,
  `check_for_transfer/1`, and `list/1`. Also defines the shared
  `status_code()` enum and its human-readable descriptions, reused as the
  `:status` field's `Ecto.Enum` values by `DonDominio.Domain.Create` and
  `DonDominio.Domain.Renew`.
  """
  use DonDominio.Schema

  @type status_code() ::
          :"register-init"
          | :"register-pending"
          | :"register-cancel"
          | :"transfer-init"
          | :"transfer-pending"
          | :"transfer-cancel"
          | :inactive
          | :active
          | :renewed
          | :"expired-renewgrace"
          | :"expired-redemption"
          | :"expired-prendingdelete"

  @statuses [
    "register-init": "Registration pending",
    "register-pending": "Registration in process",
    "register-cancel": "Registration cancelled",
    "transfer-init": "Transfer not started",
    "transfer-pending": "Transfer pending",
    "transfer-cancel": "Transfer cancelled",
    inactive: "Inactive",
    active: "Active",
    renewed: "Renewal in process",
    "expired-renewgrace": "Expired (Under grace period)",
    "expired-redemption": "Expired (Redemption period)",
    "expired-prendingdelete": "Expired (Pending deletion)"
  ]

  @primary_key false
  typed_embedded_schema do
    field(:name, :string)
    field(:status, Ecto.Enum, values: @statuses)
    field(:tld, :string)
    field(:tsExpir, :date)
    field(:domainID, :integer)
  end

  @doc """
  The `status_code()` -> human-readable description mapping, also used as
  the `Ecto.Enum` values for the `:status` field on this and related schemas.
  """
  def statuses, do: @statuses

  @doc false
  def normalize(params) when not is_struct(params) and is_map(params) do
    params =
      params
      |> change_if("tsExpir", "", nil)

    Ecto.embedded_load(__MODULE__, params, :json)
  end
end
