defmodule AstarteNervesLedExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  alias AstarteNervesLedExample.Config
  alias Astarte.Device

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AstarteNervesLedExample.Supervisor]

    with :ok <- Config.validate!() do
      children =
        [
          # Children for all targets
          # Starts a worker by calling: AstarteNervesLedExample.Worker.start_link(arg)
          # {AstarteNervesLedExample.Worker, arg},
        ] ++ children(target())

      Supervisor.start_link(children, opts)
    else
      {:error, reason} ->
        Logger.warn("Configuration incomplete. Unable to start process with reason: #{reason}.")
        {:shutdown, reason}
    end
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: AstarteNervesLedExample.Worker.start_link(arg)
      # {AstarteNervesLedExample.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: AstarteNervesLedExample.Worker.start_link(arg)
      {Device, Config.device_opts()}
    ]
  end

  def target() do
    Application.get_env(:astarte_nerves_led_example, :target)
  end
end
