defmodule MoneyButton.AccessTokenTest do
  use ExUnit.Case
  doctest MoneyButton.AccessToken

  test "expires_at is calculated correctly" do
    token =
      %{
        "access_token" => "footoken",
        "expires_in" => 3600,
        "scope" => "application_access:write",
        "token_type" => "Bearer"
      }
      |> MoneyButton.AccessToken.create()

    expected_time = DateTime.from_unix!(:os.system_time(:second) + 3600)

    assert token.expires_at.day == expected_time.day
    assert token.expires_at.month == expected_time.month
    assert token.expires_at.year == expected_time.year
    assert token.expires_at.hour == expected_time.hour
    assert token.expires_at.minute == expected_time.minute
    # Do not assert on seconds to avoid false positives. Should be good enough :).
  end
end
