defmodule AstarteNervesLedExample.Handler do
  use Astarte.Device.Handler

  alias Nerves.Leds
  alias Astarte.Device

  require Logger

  def init_state(_args) do
    {:ok, nil}
  end

  def handle_message(
        %Astarte.Device.Handler.Message{
          device_id: device_id,
          interface_name: "org.astarte-examples.LEDCommand",
          path_tokens: [led_name, "turnOn"],
          realm: realm,
          value: value
        } = message,
        state
      )
      when led_name in ["led0", "led1"] do
    Logger.info("Message received: #{inspect(message)}")

    Leds.set(led_name, value)

    with {:ok, device_pid} <- fetch_device_pid(realm, device_id),
         path = Path.join(["/", led_name, "turnedOn"]),
         :ok <- Device.set_property(device_pid, "org.astarte-examples.LEDIndicator", path, value) do
      Logger.info("Publishing back data")
    else
      e ->
        Logger.warn("Something went wrong. Error: #{inspect(e)}")
    end

    {:ok, state}
  end

  def handle_message(
        %Astarte.Device.Handler.Message{interface_name: "org.astarte-examples.LEDCommand"} =
          message,
        state
      ) do
    Logger.warn("Wrong LED name for message: #{inspect(message)}")

    {:ok, state}
  end

  def handle_message(message, state) do
    Logger.warn("Neglecting message: #{inspect(message)}")

    {:ok, state}
  end

  defp fetch_device_pid(realm, device_id) do
    case Device.get_pid(realm, device_id) do
      nil -> {:error, :unregistered_device}
      pid -> {:ok, pid}
    end
  end
end
