defmodule MoneyButton.Profile do
  @moduledoc """
  Defines a MoneyButton profile.
  """

  @enforce_keys [
    :id,
    :name
  ]

  @typedoc """
  A MoneyButton profile.
  """
  defstruct [
    :id,
    :name,
    :avatar,
    :bio,
    :created_at,
    :default_currency,
    :default_language,
    :primary_paymail
  ]

  @type t :: %__MODULE__{
          id: non_neg_integer(),
          name: String.t(),
          avatar: URI.t() | nil,
          bio: String.t() | nil,
          created_at: DateTime.t() | nil,
          default_currency: String.t() | nil,
          default_language: String.t() | nil,
          primary_paymail: String.t() | nil
        }

  @doc """
  Creates an identity the raw input (as delivered by the API).
  """
  @spec create(map()) :: __MODULE__.t()
  def create(%{"id" => user_id, "attributes" => params, "type" => "profiles"}) do
    %__MODULE__{
      id: String.to_integer(user_id),
      name: Map.get(params, "name"),
      avatar: params |> Map.get("avatar-url") |> create_avatar(),
      bio: Map.get(params, "bio"),
      created_at: params |> Map.get("created-at") |> create_date(),
      default_currency: Map.get(params, "default-currency"),
      default_language: Map.get(params, "default-language"),
      primary_paymail: Map.get(params, "primary-paymail")
    }
  end

  @spec create_date(String.t()) :: URI.t()
  @spec create_date(nil) :: nil
  defp create_date(nil), do: nil
  defp create_date(date), do: DateTime.from_iso8601(date) |> elem(1)

  @spec create_avatar(String.t()) :: URI.t()
  @spec create_avatar(nil) :: nil
  defp create_avatar(nil), do: nil
  defp create_avatar(avatar), do: URI.parse(avatar)
end
