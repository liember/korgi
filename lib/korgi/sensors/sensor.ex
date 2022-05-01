defmodule Korgi.Sensors.Sensor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sensors" do
    field :name, :string
    field :topic, :string

    has_many :readings, Korgi.Readings.Reading

    timestamps()
  end

  @doc false
  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:name, :topic])
    |> validate_required([:name, :topic])
  end
end
