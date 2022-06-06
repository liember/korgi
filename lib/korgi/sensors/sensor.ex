defmodule Korgi.Sensors.Sensor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sensors" do
    field :name, :string
    field :topic, :string
    field :enabled, :boolean, default: true
    belongs_to :broker, Korgi.MQTT.Broker
    has_many :readings, Korgi.Sensors.Reading

    timestamps()
  end

  @doc false
  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:name, :topic, :enabled, :broker_id])
    |> validate_required([:name, :topic, :enabled, :broker_id])
    |> unique_constraint(:name)
    |> unique_constraint(:topic)
    |> foreign_key_constraint(:broker_id)
  end
end
