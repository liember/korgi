defmodule Korgi.MQTT.Handler do
  use Tortoise.Handler
  require Logger

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
    Logger.info("Connection status #{inspect(status)} and state #{inspect(state)}", [
      :application,
      :mfa
    ])

    {:ok, state}
  end

  #  topic filter room/+/temp
  @impl true
  def handle_message(["room", _room, "temp"], _payload, state) do
    Logger.info("handle_message state #{inspect(state)}", [
      :application,
      :mfa
    ])

    # :ok = Temperature.record(room, payload)
    {:ok, state}
  end

  @impl true
  def handle_message(_topic, _payload, state) do
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.
    Logger.info("handle_message state #{inspect(state)}", [
      :application,
      :mfa
    ])

    {:ok, state}
  end

  @impl true
  def subscription(_status, _topic_filter, state) do
    Logger.info("subscription state #{inspect(state)}", [
      :application,
      :mfa
    ])

    {:ok, state}
  end

  @impl true
  def terminate(reason, state) do
    Logger.info("terminate wit reason #{inspect(reason)} and state  #{inspect(state)}", [
      :application,
      :mfa
    ])

    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end
end
