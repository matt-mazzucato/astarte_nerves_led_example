defmodule AstarteNervesLedExample.Config.AstarteMessageHandler do
  use Skogsra.Type

  def cast(value) when is_binary(value) do
    case value do
      "default" ->
        {:ok, {AstarteNervesLedExample.Handler, []}}

      _ ->
        :error
    end
  end

  def cast(_) do
    :error
  end
end
