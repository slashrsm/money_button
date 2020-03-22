defmodule MoneyButtonTest do
  import Mock
  use ExUnit.Case
  doctest MoneyButton

  @client_id "aWiYcnE8XArAOz9F8eC69HYPgebLQ7CnlSRkRDDgHiNeOfM1MPCnbCP3i3w4lXf1"
  @client_secret "E8n2pyyMu1u2GDjVng5tqIGQMd5GH5Vs2KLlaD9Db9VDWTaqXhyd7NIjLJhW9iCP"

  test_with_mock "auth_as_application/2", HTTPoison,
    post: fn
      "https://www.moneybutton.com/oauth/v1/token",
      "grant_type=client_credentials&scope=application_access%3Awrite",
      [
        {"Authorization",
         "Basic YVdpWWNuRThYQXJBT3o5RjhlQzY5SFlQZ2ViTFE3Q25sU1JrUkREZ0hpTmVPZk0xTVBDbmJDUDNpM3c0bFhmMTpFOG4ycHl5TXUxdTJHRGpWbmc1dHFJR1FNZDVHSDVWczJLTGxhRDlEYjlWRFdUYXFYaHlkN05JakxKaFc5aUNQ"},
        {"Content-Type", "application/x-www-form-urlencoded"}
      ] ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             Jason.encode!(%{
               "access_token" =>
                 "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw",
               "expires_in" => 3600,
               "scope" => "application_access:write",
               "token_type" => "Bearer"
             })
         }}

      "https://www.moneybutton.com/oauth/v1/token",
      "grant_type=client_credentials&scope=payments%3Aread",
      [
        {"Authorization",
         "Basic YVdpWWNuRThYQXJBT3o5RjhlQzY5SFlQZ2ViTFE3Q25sU1JrUkREZ0hpTmVPZk0xTVBDbmJDUDNpM3c0bFhmMTpFOG4ycHl5TXUxdTJHRGpWbmc1dHFJR1FNZDVHSDVWczJLTGxhRDlEYjlWRFdUYXFYaHlkN05JakxKaFc5aUNQ"},
        {"Content-Type", "application/x-www-form-urlencoded"}
      ] ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             Jason.encode!(%{
               "access_token" =>
                 "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw",
               "expires_in" => 3600,
               "scope" => "payments:read",
               "token_type" => "Bearer"
             })
         }}
    end do
    response = MoneyButton.auth_as_application!(@client_id, @client_secret)
    %MoneyButton.AccessToken{} = response

    expected = %MoneyButton.AccessToken{
      expires_at: DateTime.from_unix!(:os.system_time(:second) + 3600),
      scope: :application_write,
      token:
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw",
      token_type: :bearer
    }

    assert response.scope == expected.scope
    assert response.token_type == expected.token_type
    assert response.token == expected.token
    assert response.expires_at.year == expected.expires_at.year
    assert response.expires_at.month == expected.expires_at.month
    assert response.expires_at.day == expected.expires_at.day
    assert response.expires_at.hour == expected.expires_at.hour
    assert response.expires_at.minute == expected.expires_at.minute

    {:ok, response} = MoneyButton.auth_as_application(@client_id, @client_secret)
    %MoneyButton.AccessToken{} = response

    assert response.scope == :application_write
    assert response.token_type == :bearer

    assert response.token ==
             "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw"

    expected_expires_at = DateTime.from_unix!(:os.system_time(:second) + 3600)
    assert response.expires_at.year == expected_expires_at.year
    assert response.expires_at.month == expected_expires_at.month
    assert response.expires_at.day == expected_expires_at.day
    assert response.expires_at.hour == expected_expires_at.hour
    assert response.expires_at.minute == expected_expires_at.minute

    response = MoneyButton.auth_as_application!(@client_id, @client_secret)
    %MoneyButton.AccessToken{} = response

    assert response.scope == :application_write
    assert response.token_type == :bearer

    assert response.token ==
             "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw"

    expected_expires_at = DateTime.from_unix!(:os.system_time(:second) + 3600)
    assert response.expires_at.year == expected_expires_at.year
    assert response.expires_at.month == expected_expires_at.month
    assert response.expires_at.day == expected_expires_at.day
    assert response.expires_at.hour == expected_expires_at.hour
    assert response.expires_at.minute == expected_expires_at.minute

    {:ok, response} = MoneyButton.auth_as_application(@client_id, @client_secret, :payments_read)
    %MoneyButton.AccessToken{} = response

    assert response.scope == :payments_read
    assert response.token_type == :bearer

    assert response.token ==
             "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw"

    expected_expires_at = DateTime.from_unix!(:os.system_time(:second) + 3600)
    assert response.expires_at.year == expected_expires_at.year
    assert response.expires_at.month == expected_expires_at.month
    assert response.expires_at.day == expected_expires_at.day
    assert response.expires_at.hour == expected_expires_at.hour
    assert response.expires_at.minute == expected_expires_at.minute

    {:ok, response} =
      MoneyButton.auth_as_application(@client_id, @client_secret, :application_write)

    %MoneyButton.AccessToken{} = response

    assert response.scope == :application_write
    assert response.token_type == :bearer

    assert response.token ==
             "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OGJlYWVlYzJkMWM4ZGVlMDJjMmI3MTM1YWVmMzllMyIsImV4cCI6MTU4NDkwOTMxMCwic2NvcGUiOiJhcHBsaWNhdGlvbl9hY2Nlc3M6d3JpdGUifQ.3ruUKTJ_DwbnR-E06KU5pjMoFTH9cgwf7d6tnqpytYw"

    expected_expires_at = DateTime.from_unix!(:os.system_time(:second) + 3600)
    assert response.expires_at.year == expected_expires_at.year
    assert response.expires_at.month == expected_expires_at.month
    assert response.expires_at.day == expected_expires_at.day
    assert response.expires_at.hour == expected_expires_at.hour
    assert response.expires_at.minute == expected_expires_at.minute
  end

end
