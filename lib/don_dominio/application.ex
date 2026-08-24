defmodule DonDominio.Application do
  @moduledoc """
  Starts the `DonDominio.Finch` HTTP pool, the request telemetry logger
  (`DonDominio.Telemetry`), and `DonDominio.Account.ZoneCache`.
  """
  use Application

  @impl true
  @doc false
  def start(_start_type, _start_args) do
    DonDominio.Telemetry.attach()

    children = [
      {Finch, name: DonDominio.Finch},
      DonDominio.Account.ZoneCache
    ]

    opts = [name: DonDominio.Supervisor, strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
