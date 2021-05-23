defmodule AstarteNervesLedExample.Config do
  use Skogsra

  alias AstarteNervesLedExample.Config.AstarteMessageHandler

  @type device_options :: Astarte.Device.device_options()

  @envdoc "Astarte Pairing URL (e.g. https://api.astarte.example.com/pairing)."
  app_env :pairing_url, :astarte_nerves_led_example, :pairing_url,
    os_env: "ASTARTE_PAIRING_URL",
    type: :binary,
    required: true

  @envdoc "Realm name."
  app_env :realm, :astarte_nerves_led_example, :realm,
    os_env: "ASTARTE_REALM",
    type: :binary,
    required: true

  @envdoc "An Astarte device ID, which is a valid UUID encoded with standard Astarte device_id encoding (Base64 url encoding, no padding)."
  app_env :device_id, :astarte_nerves_led_example, :device_id,
    os_env: "ASTARTE_DEVICE_ID",
    type: :binary,
    required: true

  app_env :credentials_secret, :astarte_nerves_led_example, :credentials_secret,
    os_env: "ASTARTE_CREDENTIALS_SECRET",
    type: :binary,
    required: true

  @envdoc "Ignore SSL errors. Defaults to false. Changing the value to true is not advised for production environments unless you're aware of what you're doing."
  app_env :ignore_ssl_errors, :astarte_nerves_led_example, :ignore_ssl_errors,
    os_env: "ASTARTE_IGNORE_SSL_ERRORS",
    type: :boolean,
    default: false

  @envdoc "Set the message handler to be used. Only \"default\" is currently supported. Defaults to AstarteNervesLedExample.Handler, which is currently the only one that can be set. Add your own logic to AstarteNervesLedExample.Config.AstarteMessageHandler to add support for your own custom types."
  app_env :astarte_message_handler, :astarte_nerves_led_example, :astarte_message_handler,
    os_env: "ASTARTE_MESSAGE_HANDLER",
    type: AstarteMessageHandler,
    default: {AstarteNervesLedExample.Handler, []}

  @spec device_opts() :: device_options()
  def device_opts do
    [
      pairing_url: pairing_url!(),
      realm: realm!(),
      device_id: device_id!(),
      credentials_secret: credentials_secret!(),
      interface_provider: standard_interface_provider!(),
      ignore_ssl_errors: ignore_ssl_errors!(),
      handler: astarte_message_handler!()
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
