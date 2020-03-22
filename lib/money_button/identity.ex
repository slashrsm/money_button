defmodule MoneyButton.Identity do
  @moduledoc """
  Defines a MoneyButton identity.
  """

  @enforce_keys [
    :id,
    :name
  ]

  @typedoc """
  A MoneyButton identity.
  """
  defstruct [
    :id,
    :name
  ]

  @type t :: %__MODULE__{
          id: non_neg_integer(),
          name: String.t()
        }

  @doc """
  Creates an identity the raw input (as delivered by the API).
  """
  @spec create(map()) :: __MODULE__.t()
  def create(%{"id" => user_id, "attributes" => %{"name" => name}, "type" => "user_identities"}) do
    %__MODULE__{
      id: String.to_integer(user_id),
      name: name
    }
  end
end
