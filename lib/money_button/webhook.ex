defmodule MoneyButton.Webhook do
  @moduledoc """
  Parses payment webhook requests from MoneyButton.

  ## Options
    * `:secret` - The shared secret for authorization ([see application
      configuration on MoneyButton](https://www.moneybutton.com/settings/apps)).
    * `:strict` - Whether to immediately respond with 403 if the JSON structure
      does not match. Defaults to false.

  All options supported by `Plug.Conn.read_body/2` are also supported here.

  They are repeated here for convenience:
    * `:length` - sets the maximum number of bytes to read from the request,
      defaults to 8_000_000 bytes
    * `:read_length` - sets the amount of bytes to read at one time from the
      underlying socket to fill the chunk, defaults to 1_000_000 bytes
    * `:read_timeout` - sets the timeout for each socket read, defaults to
      15_000ms

  So by default, `Plug.Parsers` will read 1_000_000 bytes at a time from the
  socket with an overall limit of 8_000_000 bytes.
  """

  alias MoneyButton.Payment

  @behaviour Plug.Parsers

  def init(opts) do
    {secret, opts} = Keyword.pop(opts, :secret)
    {strict, opts} = Keyword.pop(opts, :strict, false)
    {body_reader, opts} = Keyword.pop(opts, :body_reader, {Plug.Conn, :read_body, []})
    {body_reader, secret, strict, opts}
  end

  def parse(conn, "application", "json", _headers, {{mod, fun, args}, expected_secret, strict, opts}) do
    with {:ok, body, conn} <- apply(mod, fun, [conn, opts | args]),
      {:ok, %{"secret" => actual_secret, "payment" => raw_payment}} <- Jason.decode(body),
      payment <- Payment.create(raw_payment) do

      if actual_secret == expected_secret do
        {:ok, payment, conn}
      else
        {:ok, %{}, conn |> Plug.Conn.send_resp(403, "Forbidden!")}
      end

    else
      _ ->
        if strict do
          {:ok, %{}, conn |> Plug.Conn.send_resp(403, "Forbidden!")}
        else
          {:next, conn}
        end
    end
  end

  def parse(conn, _type, _subtype, _headers, _options) do
    {:next, conn}
  end
end
