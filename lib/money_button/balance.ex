defmodule MoneyButton.Balance do
  @moduledoc """
  Defines a MoneyButton balance.
  """

  @enforce_keys [
    :amount,
    :satoshis,
    :currency
  ]

  @typedoc """
  A MoneyButton balance.
  """
  defstruct [
    :amount,
    :satoshis,
    :currency
  ]

  @type t :: %__MODULE__{
          amount: float(),
          currency: String.t(),
          satoshis: non_neg_integer()
        }

  @doc """
  Creates a balance from the raw input (as delivered by the API).
  """
  @spec create(map()) :: __MODULE__.t()
  def create(%{
        "attributes" => %{"amount" => amount, "currency" => currency, "satoshis" => satoshis},
        "type" => "amounts"
      }) do
    %__MODULE__{
      amount: amount,
      currency: currency,
      satoshis: String.to_integer(satoshis)
    }
  end
end
