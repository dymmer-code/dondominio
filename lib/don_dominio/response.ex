defmodule DonDominio.Response do
  @moduledoc """
  Normalize and handle response from DonDominio / MrDomain.
  """
  use TypedEctoSchema
  alias DonDominio.Account.Info, as: AccountInfo
  alias DonDominio.Account.Promo
  alias DonDominio.Account.Zone
  alias DonDominio.Common.QueryInfo
  alias DonDominio.Contact.Info, as: ContactInfo
  alias DonDominio.Domain.Billing
  alias DonDominio.Domain.Check
  alias DonDominio.Domain.CheckForTransfer
  alias DonDominio.Domain.Create
  alias DonDominio.Domain.Info, as: DomainInfo
  alias DonDominio.Domain.Renew
  alias DonDominio.Domain.Status

  @primary_key false
  typed_embedded_schema do
    field(:success, :boolean)
    field(:errorCode, :integer)
    field(:errorMsg, :string)
    field(:action, :string)
    field(:version, :string)
    field(:messages, {:array, :string})
    field(:responseData, :map)
  end

  def err_msg(0), do: "Success"
  def err_msg(1), do: "Undefined error"
  def err_msg(100), do: "Syntax error"
  def err_msg(101), do: "Syntax error: parameter fault"
  def err_msg(102), do: "Invalid object/action"
  def err_msg(103), do: "Not allowed object/action"
  def err_msg(104), do: "Not implemented object/action"
  def err_msg(105), do: "Syntax error: invalid parameter"
  def err_msg(200), do: "Login required"
  def err_msg(201), do: "Login invalid"
  def err_msg(210), do: "Session invalid"
  def err_msg(300), do: "Action not allowed"
  def err_msg(1000), do: "Account blocked"
  def err_msg(1001), do: "Account deleted"
  def err_msg(1002), do: "Account inactive"
  def err_msg(1003), do: "Account not exists"
  def err_msg(1004), do: "Account invalid pass"
  def err_msg(1005), do: "Account invalid pass"
  def err_msg(1006), do: "Account blocked"
  def err_msg(1007), do: "Account filtered"
  def err_msg(1009), do: "Account invalid pass"
  def err_msg(1010), do: "Account blocked"
  def err_msg(1011), do: "Account blocked"
  def err_msg(1012), do: "Account blocked"
  def err_msg(1013), do: "Account blocked"
  def err_msg(1014), do: "Account filtered"
  def err_msg(1030), do: "Account banned"
  def err_msg(1100), do: "Insufficient balance"
  def err_msg(2001), do: "Invalid domain name"
  def err_msg(2002), do: "TLD not supported"
  def err_msg(2003), do: "TLD in maintenance"
  def err_msg(2004), do: "Domain check error"
  def err_msg(2005), do: "Domain transfer not allowed"
  def err_msg(2006), do: "Domain Whois not allowed"
  def err_msg(2007), do: "Domain Whois error"
  def err_msg(2008), do: "Domain not found"
  def err_msg(2009), do: "Domain create error"
  def err_msg(2010), do: "Domain create error: taken"
  def err_msg(2011), do: "Domain create error: Domain premium"
  def err_msg(2012), do: "Domain transfer error"
  def err_msg(2100), do: "Domain renew error"
  def err_msg(2101), do: "Domain renew not allowed"
  def err_msg(2102), do: "Domain renew blocked"
  def err_msg(2200), do: "Domain update error"
  def err_msg(2201), do: "Domain update not allowed"
  def err_msg(2202), do: "Domain update blocked"
  def err_msg(2210), do: "Invalid operation due to the owner contact data verification status"
  def err_msg(3001), do: "Contact not exists"
  def err_msg(3002), do: "Contact data error"
  def err_msg(3003), do: "Invalid operation due to the contact data verification"
  def err_msg(3500), do: "User not exists"
  def err_msg(3501), do: "User create error"
  def err_msg(3502), do: "User update error"
  def err_msg(4001), do: "Service not found"
  def err_msg(4002), do: "Service entity not found"
  def err_msg(4003), do: "Maximum amount of entities error (FTP/Mails/etc.)"
  def err_msg(4004), do: "Failure to create the entity"
  def err_msg(4005), do: "Failure to update the entity"
  def err_msg(4006), do: "Failure to delete the entity"
  def err_msg(4007), do: "Failure to create the service"
  def err_msg(4008), do: "Failure to upgrade the service"
  def err_msg(4009), do: "Failure to renew the service"
  def err_msg(4010), do: "Failure to notify the parking system"
  def err_msg(5000), do: "SSL Error"
  def err_msg(5001), do: "SSL Not Found"
  def err_msg(10_001), do: "WebConstructor Error"

  @doc """
  Transform the parameters received from the check calls to the structure.
  """
  def normalize(%{"responseData" => data} = params) when is_list(data) do
    params
    |> Map.put("responseData", %{"data" => data})
    |> normalize()
  end

  def normalize(params) do
    Ecto.embedded_load(__MODULE__, params, :json)
    |> populate_error_msg()
    |> response_data()
  end

  defp populate_error_msg(%__MODULE__{errorCode: error_code} = response) do
    %__MODULE__{response | errorMsg: err_msg(error_code)}
  end

  defp response_data(%__MODULE__{action: "domain/check"} = response) do
    domains = Enum.map(response.responseData["domains"], &Check.normalize/1)
    %__MODULE__{response | responseData: %{domains: domains}}
  end

  defp response_data(%__MODULE__{action: "domain/checkfortransfer"} = response) do
    domains = Enum.map(response.responseData["domains"], &CheckForTransfer.normalize/1)
    %__MODULE__{response | responseData: %{domains: domains}}
  end

  @pay_actions ~w(
    domain/create
    domain/transfer
  )

  defp response_data(%__MODULE__{action: actions} = response) when actions in @pay_actions do
    billing = Billing.normalize(response.responseData["billing"])
    domains = Enum.map(response.responseData["domains"], &Create.normalize/1)
    %__MODULE__{response | responseData: %{billing: billing, domains: domains}}
  end

  defp response_data(%__MODULE__{action: "domain/renew"} = response) do
    billing = Billing.normalize(response.responseData["billing"])
    domains = Enum.map(response.responseData["domains"], &Renew.normalize/1)
    %__MODULE__{response | responseData: %{billing: billing, domains: domains}}
  end

  @status_actions ~w(
    domain/transferrestart
    domain/update
  )

  defp response_data(%__MODULE__{action: action} = response) when action in @status_actions do
    info = Status.normalize(response.responseData)
    %__MODULE__{response | responseData: info}
  end

  defp response_data(%__MODULE__{action: "domain/list"} = response) do
    query_info = QueryInfo.normalize(response.responseData["queryInfo"])
    domains = Enum.map(response.responseData["domains"], &DomainInfo.normalize/1)
    %__MODULE__{response | responseData: %{queryInfo: query_info, domains: domains}}
  end

  defp response_data(%__MODULE__{action: "domain/getinfo"} = response) do
    info = DomainInfo.normalize(response.responseData)
    %__MODULE__{response | responseData: info}
  end

  defp response_data(%__MODULE__{action: "domain/whois"} = response) do
    info = %{
      domain: response.responseData["domain"],
      whoisData: response.responseData["whoisData"]
    }

    %__MODULE__{response | responseData: info}
  end

  @contact_info_actions ~w(
    contact/create
    contact/getinfo
  )

  defp response_data(%__MODULE__{action: actions} = response)
       when actions in @contact_info_actions do
    contact = ContactInfo.normalize(response.responseData)
    %__MODULE__{response | responseData: contact}
  end

  defp response_data(%__MODULE__{action: "contact/list"} = response) do
    query_info = QueryInfo.normalize(response.responseData["queryInfo"])
    contacts = Enum.map(response.responseData["contacts"], &ContactInfo.normalize/1)
    %__MODULE__{response | responseData: %{queryInfo: query_info, contacts: contacts}}
  end

  defp response_data(%__MODULE__{action: "account/info"} = response) do
    info = AccountInfo.normalize(response.responseData)
    %__MODULE__{response | responseData: info}
  end

  defp response_data(%__MODULE__{action: "account/promos"} = response) do
    promos = Enum.map(response.responseData["data"], &Promo.normalize/1)
    %__MODULE__{response | responseData: promos}
  end

  defp response_data(%__MODULE__{action: "account/zones"} = response) do
    query_info = QueryInfo.normalize(response.responseData["queryInfo"])
    zones = Enum.map(response.responseData["zones"], &Zone.normalize/1)
    %__MODULE__{response | responseData: %{queryInfo: query_info, zones: zones}}
  end

  def process({:ok, %Tesla.Env{status: 200, body: body}}),
    do: {:ok, normalize(Jason.decode!(body))}

  def process({:ok, %Tesla.Env{status: status, body: body}}),
    do: {:error, {status, body}}

  def process({:error, _reason} = error), do: error
end
