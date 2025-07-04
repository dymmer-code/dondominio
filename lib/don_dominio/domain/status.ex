defmodule DonDominio.Domain.Status do
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

  def statuses, do: @statuses

  def normalize(params) when not is_struct(params) and is_map(params) do
    params =
      params
      |> change_if("tsExpir", "", nil)

    Ecto.embedded_load(__MODULE__, params, :json)
  end
end
