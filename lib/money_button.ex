defmodule MoneyButton do
  @moduledoc """
  Documentation for `MoneyButton`.
  """

  alias MoneyButton.AuthScope
  alias MoneyButton.AccessToken
  alias MoneyButton.Payment
  alias MoneyButton.Identity

  @url "https://www.moneybutton.com"

  @doc """
  Authenticate as an application.

  This function will raise an exception in case of an error.
  """
  @spec auth_as_application!(String.t(), String.t(), AuthScope.t()) :: AccessToken.t()
  def auth_as_application!(client_id, client_secret, scope \\ :application_write) do
    credentials = "#{client_id}:#{client_secret}" |> Base.encode64()

    {:ok, %HTTPoison.Response{status_code: 200, body: tokens}} =
      HTTPoison.post(
        @url <> "/oauth/v1/token",
        URI.encode_query(%{
          grant_type: "client_credentials",
          scope: AuthScope.convert(scope)
        }),
        [
          {"Authorization", "Basic #{credentials}"},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    tokens
    |> Jason.decode!()
    |> AccessToken.create()
  end

  @doc """
  Authenticate as an application.
  """
  @spec auth_as_application(String.t(), String.t(), AuthScope.t()) ::
          {:ok, AccessToken.t()} | {:error, String.t()}
  def auth_as_application(client_id, client_secret, scope \\ :application_write) do
    {:ok, auth_as_application!(client_id, client_secret, scope)}
  rescue
    MatchError -> {:error, "Authorization request failed."}
    _ -> {:error, "Unable to authorize."}
  end

  @doc """
  Authenticate as user.

  This function will raise an exception in case of an error.
  """
  @spec auth_as_user!(String.t(), String.t(), String.t()) :: AccessToken.t()
  def auth_as_user!(oauth_client_id, authorization_code, redirect_uri) do
    {:ok, %HTTPoison.Response{status_code: 200, body: tokens}} =
      HTTPoison.post(
        @url <> "/oauth/v1/token",
        URI.encode_query(%{
          grant_type: "authorization_code",
          code: authorization_code,
          redirect_uri: redirect_uri,
          client_id: oauth_client_id
        }),
        [{"Content-Type", "application/x-www-form-urlencoded"}]
      )

    tokens
    |> Jason.decode!()
    |> AccessToken.create()
  end

  @doc """
  Authenticate as a user.
  """
  @spec auth_as_user(String.t(), String.t(), String.t()) ::
          {:ok, AccessToken.t()} | {:error, String.t()}
  def auth_as_user(oauth_client_id, authorization_code, redirect_uri) do
    {:ok, auth_as_user!(oauth_client_id, authorization_code, redirect_uri)}
  rescue
    MatchError -> {:error, "Authorization request failed."}
    _ -> {:error, "Unable to authorize."}
  end

  @doc """
  Get all payments for an application.

  This function will raise an exception in case of an error.
  """
  @spec get_payments!(MoneyButton.AccessToken.t(), non_neg_integer(), non_neg_integer()) :: [
          Payment.t()
        ]
  def get_payments!(%AccessToken{token: token}, limit \\ 20, offset \\ 0) do
    {:ok, %HTTPoison.Response{status_code: 200, body: payments}} =
      HTTPoison.get(
        @url <> "/api/v1/payments?" <> URI.encode_query(%{"limit" => limit, "offset" => offset}),
        [
          {"Authorization", "Bearer #{token}"},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    payments
    |> Jason.decode!()
    |> Map.get("data", [])
    |> Enum.map(&Payment.create/1)
  end

  @doc """
  Get all payments for an application.
  """
  @spec get_payments(MoneyButton.AccessToken.t(), non_neg_integer(), non_neg_integer()) ::
          {:ok, [Payment.t()]} | {:error, String.t()}
  def get_payments(%AccessToken{} = access_token, limit \\ 20, offset \\ 0) do
    {:ok, get_payments!(access_token, limit, offset)}
  rescue
    MatchError -> {:error, "Request failed."}
    _ -> {:error, "Unable to process the response."}
  end

  @doc """
  Get a payment for an application.

  This function will raise an exception in case of an error.
  """
  @spec get_payment!(MoneyButton.AccessToken.t(), non_neg_integer()) :: Payment.t()
  def get_payment!(%AccessToken{token: token}, payment_id) when is_integer(payment_id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: payments}} =
      HTTPoison.get(
        @url <> "/api/v1/payments/#{payment_id}",
        [
          {"Authorization", "Bearer #{token}"},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    payments
    |> Jason.decode!()
    |> Map.get("data", %{})
    |> Payment.create()
  end

  @doc """
  Get all payment for an application.
  """
  @spec get_payment(MoneyButton.AccessToken.t(), non_neg_integer()) ::
          {:ok, Payment.t()} | {:error, String.t()}
  def get_payment(%AccessToken{} = access_token, payment_id) do
    {:ok, get_payment!(access_token, payment_id)}
  rescue
    MatchError -> {:error, "Request failed."}
    _ -> {:error, "Unable to process the response."}
  end

  @doc """
  Get a user identity.

  This function will raise an exception in case of an error.
  """
  @spec get_identity!(MoneyButton.AccessToken.t()) :: Identity.t()
  def get_identity!(%AccessToken{token: token}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: data}} =
      HTTPoison.get(
        @url <> "/api/v1/auth/user_identity",
        [
          {"Authorization", "Bearer #{token}"},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    data
    |> Jason.decode!()
    |> Map.get("data", %{})
    |> Identity.create()
  end

  @doc """
  Get a user identity.
  """
  @spec get_identity(MoneyButton.AccessToken.t()) ::
          {:ok, Identity.t()} | {:error, String.t()}
  def get_identity(%AccessToken{} = access_token) do
    {:ok, get_identity!(access_token)}
  rescue
    MatchError -> {:error, "Request failed."}
    _ -> {:error, "Unable to process the response."}
  end
end
