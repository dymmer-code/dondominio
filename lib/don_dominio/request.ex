defmodule DonDominio.Request do
  @moduledoc """
  The functions and macros needed to make easier the request to the web
  service. Only add the following header in the new module:

  ```elixir
  use DonDominio.Request
  ```

  And then you can use `request/2` inside of your functions.
  """
  alias DonDominio.Response

  @doc false
  defmacro __using__(_opts) do
    quote do
      import DonDominio.Request
    end
  end

  @doc false
  def client do
    Tesla.client(
      [
        {Tesla.Middleware.Logger,
         format: "$method /domain$url ===> $status / time=$time", log_level: :debug},
        {Tesla.Middleware.BaseUrl, Application.get_env(:don_dominio, :url)},
        ## TODO content-type: text/plain; charset=utf8
        # plug(Tesla.Middleware.DecodeJson)
        Tesla.Middleware.EncodeFormUrlencoded
      ],
      {Tesla.Adapter.Finch, name: DonDominio.Finch}
    )
  end

  @doc false
  def body(content \\ %{}) do
    Map.merge(
      %{
        apiuser: Application.get_env(:don_dominio, :apiuser),
        apipasswd: Application.get_env(:don_dominio, :apipasswd),
        "output-format": "json"
      },
      content
    )
  end

  @doc """
  For the content to be in use for the first parameter of the `request/2`
  function we could use this function to let us include a new data only
  if the value is different than _nil_.
  """
  def maybe_add(data, _name, nil), do: data
  def maybe_add(data, name, value), do: Map.put(data, name, value)

  @doc """
  Perform a request. It's creating a Tesla client, performing the POST
  action using the content (first optional parameter) to add the auth
  parameters and then perform the request using the URI passed as the
  second parameter. The response is processed using
  `DonDominio.Response.process/1`.
  """
  def request(content \\ %{}, action) do
    client()
    |> Tesla.post(action, body(content))
    |> Response.process()
  end
end
