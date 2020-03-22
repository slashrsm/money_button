defmodule MoneyButton.AccessToken do
  @moduledoc """
  MoneyButton access token.
  """
  alias MoneyButton.AuthScope
  alias MoneyButton.TokenType

  @enforce_keys [
    :token,
    :scope,
    :token_type,
    :expires_at
  ]

  @typedoc """
  A MoneyButton access token.
  """
  defstruct [
    :token,
    :scope,
    :token_type,
    :expires_at
  ]

  @type t :: %__MODULE__{
          token: String.t(),
          scope: AuthScope.t(),
          token_type: TokenType.t(),
          expires_at: DateTime.t()
        }

  @doc """
  Creates the access token from the raw response.

  ## Examples

    iex> raw = %{"access_token" => "footoken", "expires_in" => 3600, "scope" => "application_access:write", "token_type" => "Bearer"}
    iex> access_token = MoneyButton.AccessToken.create(raw)
    iex> %MoneyButton.AccessToken{} = access_token
    iex> access_token.token
    "footoken"
    iex> access_token.scope
    :application_write
    iex> access_token.token_type
    :bearer
  """
  @spec create(map()) :: MoneyButton.AccessToken.t()
  def create(%{
        "access_token" => token,
        "expires_in" => lifetime,
        "scope" => raw_scope,
        "token_type" => raw_type
      }) do
    %__MODULE__{
      token: token,
      scope: AuthScope.convert(raw_scope),
      token_type: TokenType.convert(raw_type),
      expires_at: DateTime.from_unix!(:os.system_time(:second) + lifetime)
    }
  end
end
