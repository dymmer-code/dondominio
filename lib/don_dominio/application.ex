defmodule DonDominio.Application do
  use Application

  @impl true
  @doc false
  def start(_start_type, _start_args) do
    children = [
      {Finch, name: DonDominio.Finch},
      DonDominio.Account.ZoneCache
    ]

    opts = [name: DonDominio.Supervisor, strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
