defmodule Korgi.MQTT.Broker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mqtt_brokers" do
    field :host, :string
    field :name, :string
    field :password, :string
    field :port, :integer
    field :username, :string

    has_many :sensors, Korgi.Sensors.Sensor

    timestamps()
  end

  @doc false
  def changeset(broker, attrs) do
    broker
    |> cast(attrs, [:name, :host, :port, :username, :password])
    |> validate_required([:name, :host, :port, :username, :password])
  end
end
