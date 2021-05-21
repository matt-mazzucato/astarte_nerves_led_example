defmodule AstarteNervesLedExample.Config do
  use Skogsra

  app_env :pairing_url, :astarte_nerves_led_example, :pairing_url,
    os_env: "PAIRING_URL",
    type: :binary,
    required: true

  app_env :realm, :astarte_nerves_led_example, :realm,
    os_env: "REALM",
    type: :binary,
    required: true

  app_env :device_id, :astarte_nerves_led_example, :device_id,
    os_env: "DEVICE_ID",
    type: :binary,
    required: true

  app_env :credentials_secret, :astarte_nerves_led_example, :credentials_secret,
    os_env: "CREDENTIALS_SECRET",
    type: :binary,
    required: true

  app_env :ignore_ssl_errors, :astarte_nerves_led_example, :ignore_ssl_errors,
    os_env: "IGNORE_SSL_ERRORS",
    type: :boolean,
    default: false

  def device_opts do
    [
      pairing_url: pairing_url!(),
      realm: realm!(),
      device_id: device_id!(),
      credentials_secret: credentials_secret!(),
      interface_provider: standard_interface_provider!(),
      ignore_ssl_errors: ignore_ssl_errors!(),
      handler: {AstarteNervesLedExample.Handler, []}
    ]
  end

  @spec standard_interface_provider() :: {:ok, String.t()}
  def standard_interface_provider do
    {:ok, standard_interface_provider!()}
  end

  @spec standard_interface_provider!() :: String.t()
  def standard_interface_provider! do
    :code.priv_dir(:astarte_nerves_led_example)
    |> Path.join("interfaces")
  end
end
