defmodule DonDominio.Schema.Range do
  @moduledoc """
  Define a range of numbers, useful for example for range of years
  when we want to renew a domain.
  """
  use Ecto.Type

  @type t() :: Range.t()

  @doc false
  def type, do: :string

  @doc false
  def cast(nil), do: nil

  def cast(numbers) when is_binary(numbers) do
    {:ok,
     numbers
     |> String.split(",")
     |> Enum.map(&String.to_integer/1)
     |> Enum.uniq()
     |> Enum.sort()
     |> then(&Range.new(hd(&1), List.last(&1)))}
  end

  @doc false
  def load(data), do: cast(data)

  @doc false
  def dump(data) when is_list(data) or is_struct(data, Range) do
    data
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.map_join(",", &to_string/1)
    |> then(&{:ok, &1})
  end
end
