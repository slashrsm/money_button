defmodule MoneyButton.Payment do
  @moduledoc """
  Defines a MoneyButton payment.
  """

  @enforce_keys [
    :id,
    :amount_usd,
    :amount,
    :change_amount_satoshis,
    :change_amount_usd,
    :created_at,
    :currency,
    :fee_amount_satoshis,
    :fee_amount_usd,
    :input_amount_satoshis,
    :input_amount_usd,
    :rawtx,
    :satoshis,
    :spend_amount_satoshis,
    :spend_amount_usd,
    :status,
    :txid,
    :user_id
  ]

  @typedoc """
  A MoneyButton payment.
  """
  defstruct [
    :id,
    :amount_usd,
    :browser_user_agent,
    :amount,
    :button_data,
    :button_id,
    :change_amount_satoshis,
    :change_amount_usd,
    :created_at,
    :currency,
    :fee_amount_satoshis,
    :fee_amount_usd,
    :input_amount_satoshis,
    :input_amount_usd,
    :normalized_txid,
    :rawtx,
    :referrer_url,
    :satoshis,
    :sender_paymail,
    :sender_signature,
    :signature_pubkey,
    :spend_amount_satoshis,
    :spend_amount_usd,
    :status,
    :status_description,
    :txid,
    :user_id
  ]

  @type t :: %__MODULE__{
          id: non_neg_integer(),
          amount_usd: float(),
          browser_user_agent: String.t(),
          amount: float(),
          button_data: String.t(),
          button_id: String.t(),
          change_amount_satoshis: non_neg_integer(),
          change_amount_usd: float(),
          created_at: DateTime.t(),
          currency: String.t(),
          fee_amount_satoshis: non_neg_integer(),
          fee_amount_usd: float(),
          input_amount_satoshis: non_neg_integer(),
          input_amount_usd: float(),
          normalized_txid: String.t(),
          rawtx: String.t(),
          referrer_url: URI.t(),
          satoshis: non_neg_integer(),
          sender_paymail: String.t(),
          sender_signature: String.t(),
          signature_pubkey: String.t(),
          spend_amount_satoshis: non_neg_integer(),
          spend_amount_usd: float(),
          status: :completed | :received | :pending | :failed,
          status_description: String.t(),
          txid: String.t(),
          user_id: non_neg_integer()
        }

  @doc """
  Creates a payment from the raw input (as delivered by the API).
  """
  @spec create(map()) :: __MODULE__.t()
  def create(%{"id" => payment_id, "attributes" => raw_payment, "type" => "payments"}) do
    to_struct = fn data -> struct!(__MODULE__, data) end

    raw_payment
    |> Enum.into(%{}, fn {key, value} ->
      {
        key |> String.replace("-", "_") |> String.to_existing_atom(),
        value
      }
    end)
    |> convert_date()
    |> convert_status()
    |> convert_referrer_url()
    |> convert_integer()
    |> convert_float()
    |> Map.put(:id, String.to_integer(payment_id))
    |> to_struct.()
  end

  defp convert_date(%{created_at: date} = payment) do
    {:ok, date, 0} = DateTime.from_iso8601(date)
    %{payment | created_at: date}
  end

  defp convert_referrer_url(%{referrer_url: nil} = payment), do: payment

  defp convert_referrer_url(%{referrer_url: raw_url} = payment),
    do: %{payment | referrer_url: URI.parse(raw_url)}

  defp convert_status(%{status: "COMPLETED"} = payment), do: %{payment | status: :completed}
  defp convert_status(%{status: "RECEIVED"} = payment), do: %{payment | status: :received}
  defp convert_status(%{status: "PENDING"} = payment), do: %{payment | status: :pending}
  defp convert_status(%{status: "FAILED"} = payment), do: %{payment | status: :failed}

  defp convert_integer(payment) do
    integer_keys = [
      :change_amount_satoshis,
      :fee_amount_satoshis,
      :input_amount_satoshis,
      :satoshis,
      :spend_amount_satoshis,
      :user_id
    ]

    do_convert_integer(payment, integer_keys)
  end

  defp do_convert_integer(payment, [key | rest]) do
    do_convert_integer(Map.put(payment, key, String.to_integer(payment[key])), rest)
  end

  defp do_convert_integer(payment, []), do: payment

  defp convert_float(payment) do
    float_keys = [
      :amount_usd,
      :amount,
      :change_amount_usd,
      :fee_amount_usd,
      :input_amount_usd,
      :spend_amount_usd
    ]

    do_convert_float(payment, float_keys)
  end

  defp do_convert_float(payment, [key | rest]) do
    do_convert_float(Map.put(payment, key, String.to_float(payment[key])), rest)
  end

  defp do_convert_float(payment, []), do: payment
end
