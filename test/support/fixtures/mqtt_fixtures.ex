defmodule Korgi.MQTTFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Korgi.MQTT` context.
  """

  @doc """
  Generate a broker.
  """
  def broker_fixture(attrs \\ %{}) do
    {:ok, broker} =
      attrs
      |> Enum.into(%{
        host: "some host",
        name: "some name",
        password: "some password",
        port: 42,
        username: "some username"
      })
      |> Korgi.MQTT.create_broker_mqtt()

    broker
  end
end
