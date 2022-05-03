defmodule Korgi.MQTT.Connection do
  alias Korgi.MQTT
  alias Korgi.MQTT.Broker
  alias Korgi.MQTT.Handler
  alias Korgi.Sensors.Sensor

  require Logger

  # field :host, :string
  # field :name, :string
  # field :password, :string
  # field :port, :integer
  # field :username, :string

  def init(_init_arg) do
    try do
      brokers = MQTT.list_mqtt_brokers()
      Logger.info("#{inspect(brokers)}")

      Enum.map(brokers, fn broker ->
        %Broker{
          name: name,
          password: pswd,
          host: host,
          port: port,
          username: login,
          sensors: sensors
        } = Korgi.Repo.preload(broker, :sensors)

        Tortoise.Supervisor.start_child(
          client_id: name,
          handler: {Handler, []},
          user_name: login,
          password: pswd,
          server: {Tortoise.Transport.Tcp, host: host |> String.to_charlist(), port: port},
          subscriptions: sensors |> Enum.map(fn %Sensor{topic: topic} -> {topic, 0} end)
        )
      end)
    rescue
      e -> Logger.error("Error while connecting, error: #{inspect(e)}")
    end
  end

  def subscribe(%Sensor{broker_id: broker_id, topic: topic}) do
    broker = MQTT.get_broker_mqtt!(broker_id)
    Tortoise.Connection.subscribe(broker.name, topic)
  end
end
