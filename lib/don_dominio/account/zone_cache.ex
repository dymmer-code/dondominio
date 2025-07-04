defmodule DonDominio.Account.ZoneCache do
  use GenServer

  require Logger

  alias DonDominio.Account
  alias DonDominio.Account.Zone
  alias DonDominio.Common.QueryInfo
  alias DonDominio.Response

  @default_refresh_interval :timer.hours(24)

  @wait_before_retry :timer.seconds(5)

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl GenServer
  def init([]) do
    state = %{zones: %{}}

    if Application.get_env(:don_dominio, :auto_refresh, true) do
      {:ok, Map.put(state, :timestamp, NaiveDateTime.utc_now()), {:continue, :refresh}}
    else
      {:ok, %{}}
    end
  end

  @impl GenServer
  def handle_continue(:refresh, state) do
    Logger.info("populating cache with zones")
    options = %{pageLength: 1_000}

    with {:ok, %Response{success: true} = response} <- Account.zones(options),
         %QueryInfo{} = query_info <- response.responseData[:queryInfo],
         [%Zone{} | _] = zones <- response.responseData[:zones] do
      Logger.info("retrieved #{query_info.results} of #{query_info.total}")
      timeout = Application.get_env(:don_dominio, :refresh_interval_ms, @default_refresh_interval)

      state
      |> Map.put(:zones, zones)
      |> Map.put(:timestamp, NaiveDateTime.utc_now())
      |> refresh(timeout)
    else
      error ->
        Logger.error("using (#{state.timestamp}) - cannot populate the cache: #{inspect(error)}")
        refresh(state, @wait_before_retry)
    end
  end

  defp refresh(%{timer_ref: timer_ref} = state, timeout) do
    Process.cancel_timer(timer_ref)
    refresh(Map.delete(state, :timer_ref), timeout)
  end

  defp refresh(state, timeout) do
    timer_ref = Process.send_after(self(), :refresh, timeout)
    {:noreply, Map.put(state, :timer_ref, timer_ref)}
  end

  @impl GenServer
  def handle_info(:refresh, state) do
    {:noreply, state, {:continue, :refresh}}
  end

  @impl GenServer
  def handle_call({:get_zone_by_tld, tld}, _from, state) do
    if zone = Enum.find(state.zones, &(&1.tld == tld)) do
      {:reply, {:ok, zone}, state}
    else
      {:reply, {:error, :notfound}, state}
    end
  end

  def handle_call({:get_zones_by_top_tld, tld}, _from, state) do
    case Enum.filter(state.zones, &(&1.tldtop == tld)) do
      [] -> {:reply, {:error, :notfound}, state}
      zones -> {:reply, {:ok, zones}, state}
    end
  end
end
