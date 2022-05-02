defmodule Korgi.MQTT.Connection do
  alias Korgi.MQTT
  alias Korgi.MQTT.Broker
  alias Korgi.MQTT.Handler

  # field :host, :string
  # field :name, :string
  # field :password, :string
  # field :port, :integer
  # field :username, :string

  def init(_init_arg) do
    MQTT.list_mqtt_brokers()
    |> Enum.map(fn %Broker{name: name, password: pswd, host: host, port: port, username: login} ->
      Tortoise.Supervisor.start_child(
        client_id: name,
        handler: {Handler, []},
        server:
          {Tortoise.Transport.Tcp, host: host, port: port, user_name: login, password: pswd},
        subscriptions: [{"foo/bar", 0}]
      )
    end)
  end
end
