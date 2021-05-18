defmodule AstarteNervesLedExampleTest do
  use ExUnit.Case
  doctest AstarteNervesLedExample

  test "greets the world" do
    assert AstarteNervesLedExample.hello() == :world
  end
end
