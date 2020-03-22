defmodule MoneyButton.AuthScope do
  @moduledoc """
  MoneyButton auth scope.
  """

  @type t :: :application_write | :payments_read

  @doc """
  Converts auth scope from atom to string and vice-versa.

  ## Examples

    iex> MoneyButton.AuthScope.convert(:application_write)
    "application_access:write"
    iex> MoneyButton.AuthScope.convert("application_access:write")
    :application_write
    iex> MoneyButton.AuthScope.convert(:payments_read)
    "payments:read"
    iex> MoneyButton.AuthScope.convert("payments:read")
    :payments_read
  """
  @spec convert(String.t()) :: __MODULE__.t()
  @spec convert(__MODULE__.t()) :: String.t()
  def convert("application_access:write"), do: :application_write
  def convert(:application_write), do: "application_access:write"
  def convert("payments:read"), do: :payments_read
  def convert(:payments_read), do: "payments:read"
end
