defmodule Korgi.SensorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Korgi.Sensors` context.
  """

  @doc """
  Generate a sensor.
  """
  def sensor_fixture(attrs \\ %{}) do
    {:ok, sensor} =
      attrs
      |> Enum.into(%{
        name: "some name",
        topic: "some topic"
      })
      |> Korgi.Sensors.create_sensor()

    sensor
  end
end
