defmodule MoneyButton.AuthScope do
  @moduledoc """
  MoneyButton auth scope.
  """

  @type t :: :application_write | :payments_read | :user_identity | :user_profile | :user_balance

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
    iex> MoneyButton.AuthScope.convert(:user_identity)
    "auth.user_identity:read"
    iex> MoneyButton.AuthScope.convert("auth.user_identity:read")
    :user_identity
    iex> MoneyButton.AuthScope.convert(:user_profile)
    "users.profiles:read"
    iex> MoneyButton.AuthScope.convert("users.profiles:read")
    :user_profile
    iex> MoneyButton.AuthScope.convert(:user_balance)
    "users.balance:read"
    iex> MoneyButton.AuthScope.convert("users.balance:read")
    :user_balance
  """
  @spec convert(String.t()) :: __MODULE__.t()
  @spec convert(__MODULE__.t()) :: String.t()
  def convert("application_access:write"), do: :application_write
  def convert(:application_write), do: "application_access:write"
  def convert("payments:read"), do: :payments_read
  def convert(:payments_read), do: "payments:read"
  def convert("auth.user_identity:read"), do: :user_identity
  def convert(:user_identity), do: "auth.user_identity:read"
  def convert("users.balance:read"), do: :user_balance
  def convert(:user_balance), do: "users.balance:read"
  def convert("users.profiles:read"), do: :user_profile
  def convert(:user_profile), do: "users.profiles:read"
end
