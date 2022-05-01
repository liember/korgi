defmodule Korgi.ReadingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Korgi.Readings` context.
  """

  @doc """
  Generate a reading.
  """
  def reading_fixture(attrs \\ %{}) do
    {:ok, reading} =
      attrs
      |> Enum.into(%{
        sesnor_id: 42,
        value: "some value"
      })
      |> Korgi.Readings.create_reading()

    reading
  end
end
