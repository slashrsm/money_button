defmodule MoneyButton.TokenType do
  @moduledoc """
  MoneyButton token type.
  """

  @type t :: :bearer

  @doc """
  Converts token type from atom to string and vice-versa.

  ## Examples

    iex> MoneyButton.TokenType.convert(:bearer)
    "Bearer"
    iex> MoneyButton.TokenType.convert("Bearer")
    :bearer
  """
  @spec convert(String.t()) :: __MODULE__.t()
  @spec convert(__MODULE__.t()) :: String.t()
  def convert("Bearer"), do: :bearer
  def convert(:bearer), do: "Bearer"
end
