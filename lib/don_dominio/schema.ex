defmodule DonDominio.Schema do
  @moduledoc """
  Facilities (or utilities) designed for schema implementation.
  """

  defmacro __using__(_opts) do
    quote do
      use TypedEctoSchema
      import DonDominio.Schema, only: [change_if: 4]

      @doc """
      Transform the parameters received from the check calls to the structure.
      """
      def normalize(params) do
        Ecto.embedded_load(__MODULE__, params, :json)
      end

      defoverridable normalize: 1
    end
  end

  def change_if(params, field, value, new_value) do
    if params[field] == value do
      Map.put(params, field, new_value)
    else
      params
    end
  end
end
