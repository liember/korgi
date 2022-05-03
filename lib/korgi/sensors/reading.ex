defmodule Korgi.Sensors.Reading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readings" do
    belongs_to :sensor, Korgi.Sensors.Sensor
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [:value, :sensor_id])
    |> validate_required([:value, :sensor_id])
  end
end
