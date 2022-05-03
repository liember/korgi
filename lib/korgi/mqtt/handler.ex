defmodule Korgi.MQTT.Handler do
  use Tortoise.Handler
  require Logger

  alias Korgi.Sensors

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def connection(status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    # a `:down`
    Logger.info("Connection status #{inspect(status)} and state #{inspect(state)}")
    {:ok, state}
  end

  @impl true
  def handle_message(topic, payload, state) do
    Logger.info(
      "handle_message state #{inspect(state)} topic: #{inspect(topic)}, payload: #{inspect(payload)}"
    )

    try do
      sensor =
        topic
        |> Enum.join("/")
        |> Sensors.get_sensor_id_by_topic!()
        |> Sensors.get_sensor!()

      Sensors.create_reading(%{sensor_id: sensor.id, value: payload})
    rescue
      e ->
        Logger.error("Cant find sensor with topic #{inspect(topic)} in db error: #{inspect(e)}")
    end

    {:ok, state}
  end

  @impl true
  def subscription(_status, _topic_filter, state) do
    Logger.info("subscription state #{inspect(state)}")

    {:ok, state}
  end

  @impl true
  def terminate(reason, state) do
    Logger.info("terminate wit reason #{inspect(reason)} and state  #{inspect(state)}")

    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end
end
