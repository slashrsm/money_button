defmodule MoneyButton.PaymentTest do
  use ExUnit.Case
  doctest MoneyButton.Payment

  @raw_payment %{
    "type" => "payments",
    "id" => "12345",
    "attributes" => %{
      "amount" => "0.10099961061888103",
      "amount_usd" => "0.10099961061888103",
      "browser_user_agent" =>
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:72.0) Gecko/20100101 Firefox/72.0",
      "button_data" => "some button data",
      "button_id" => "some button id",
      "change_amount_satoshis" => "219483",
      "change_amount_usd" => "0.18535019136835482",
      "created_at" => "2019-08-21T21:35:14.233Z",
      "currency" => "USD",
      "fee_amount_satoshis" => "369",
      "fee_amount_usd" => "0.000311615116500699",
      "input_amount_satoshis" => "339451",
      "input_amount_usd" => "0.28666141710373655",
      "normalized_txid" => "6b6d2820093408e81c7ce8089b9514ea12f2a9b2378d3fe4e0dc4e8bec499ed0",
      "rawtx" =>
        "0100000001f6bdfe0e545004c5d07e5662da8d0e038be248ce782804bc1aabdcefa7c1633d030000006b48304502210090d26e2fb039f88bad6f8977c05a9435c4311087e356c8b3aad76e5353ee316c022060d0a33538484d003795545f431a38f075815cbc76c70a0a9d6067024de8ef75412102d8ef7ff52c22b9f14261218ea85034d4ed683f2240343edaf3535065805b4f7affffffff04000000000000000061006a2231394878696756345179427633744870515663554551797131707a5a56646f4175741d2320546869732069732073696c6c79210a0a5465737420616e737765720d746578742f6d61726b646f776e055554462d3809616e737765722e6d64a0040000000000001976a914882709c4fe4e9012cbf20e3032603d740cf4c39c88ac8fce0100000000001976a914a022576ecca26042fe24f146184c4c53ab7e291a88ac5b590300000000001976a914a022576ecca26042fe24f146184c4c53ab7e291a88ac00000000",
      "referrer_url" => "https://example.com/some/page",
      "satoshis" => "119599",
      "sender_paymail" => "test@moneybutton.com",
      "sender_signature" => nil,
      "signature_pubkey" => nil,
      "spend_amount_satoshis" => "1553",
      "spend_amount_usd" => "0.001311485842616763",
      "status" => "COMPLETED",
      "status_description" => nil,
      "txid" => "51471de137161d1e704ebafe760246ad8f2bb67ebfa105ef272d9b7b90dc5791",
      "user_id" => "99"
    }
  }

  test "CREATED payment" do
    payment = MoneyButton.Payment.create(@raw_payment)

    %MoneyButton.Payment{} = payment

    {:ok, expected_created_at, 0} = DateTime.from_iso8601("2019-08-21T21:35:14.233Z")
    assert payment.id == 12_345
    assert payment.amount == 0.10099961061888103
    assert payment.amount_usd == 0.10099961061888103

    assert payment.browser_user_agent ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:72.0) Gecko/20100101 Firefox/72.0"

    assert payment.button_data == "some button data"
    assert payment.button_id == "some button id"
    assert payment.change_amount_satoshis == 219_483
    assert payment.change_amount_usd == 0.18535019136835482
    assert payment.created_at == expected_created_at
    assert payment.currency == "USD"
    assert payment.fee_amount_satoshis == 369
    assert payment.input_amount_satoshis == 339_451
    assert payment.input_amount_usd == 0.28666141710373655

    assert payment.normalized_txid ==
             "6b6d2820093408e81c7ce8089b9514ea12f2a9b2378d3fe4e0dc4e8bec499ed0"

    assert payment.rawtx ==
             "0100000001f6bdfe0e545004c5d07e5662da8d0e038be248ce782804bc1aabdcefa7c1633d030000006b48304502210090d26e2fb039f88bad6f8977c05a9435c4311087e356c8b3aad76e5353ee316c022060d0a33538484d003795545f431a38f075815cbc76c70a0a9d6067024de8ef75412102d8ef7ff52c22b9f14261218ea85034d4ed683f2240343edaf3535065805b4f7affffffff04000000000000000061006a2231394878696756345179427633744870515663554551797131707a5a56646f4175741d2320546869732069732073696c6c79210a0a5465737420616e737765720d746578742f6d61726b646f776e055554462d3809616e737765722e6d64a0040000000000001976a914882709c4fe4e9012cbf20e3032603d740cf4c39c88ac8fce0100000000001976a914a022576ecca26042fe24f146184c4c53ab7e291a88ac5b590300000000001976a914a022576ecca26042fe24f146184c4c53ab7e291a88ac00000000"

    assert payment.referrer_url == %URI{
             authority: "example.com",
             fragment: nil,
             host: "example.com",
             path: "/some/page",
             port: 443,
             query: nil,
             scheme: "https",
             userinfo: nil
           }

    assert payment.satoshis == 119_599
    assert payment.sender_paymail == "test@moneybutton.com"
    assert payment.sender_signature == nil
    assert payment.signature_pubkey == nil
    assert payment.spend_amount_satoshis == 1553
    assert payment.spend_amount_usd == 0.001311485842616763
    assert payment.status == :completed
    assert payment.status_description == nil
    assert payment.txid == "51471de137161d1e704ebafe760246ad8f2bb67ebfa105ef272d9b7b90dc5791"
    assert payment.user_id == 99
  end

  test "PENDING payment" do
    payment =
      @raw_payment
      |> update_in(["attributes", "status"], fn _ -> "PENDING" end)
      |> MoneyButton.Payment.create()

    %MoneyButton.Payment{} = payment

    assert payment.status == :pending
  end

  test "FAILED payment" do
    payment =
      @raw_payment
      |> update_in(["attributes", "status"], fn _ -> "FAILED" end)
      |> MoneyButton.Payment.create()

    %MoneyButton.Payment{} = payment

    assert payment.status == :failed
  end

  test "RECEIVED payment" do
    payment =
      @raw_payment
      |> update_in(["attributes", "status"], fn _ -> "RECEIVED" end)
      |> MoneyButton.Payment.create()

    %MoneyButton.Payment{} = payment

    assert payment.status == :received
  end

  test "empty referrer" do
    payment =
      @raw_payment
      |> update_in(["attributes", "referrer_url"], fn _ -> nil end)
      |> MoneyButton.Payment.create()

    %MoneyButton.Payment{} = payment

    assert payment.referrer_url == nil
  end
end
