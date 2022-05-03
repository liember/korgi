defmodule KorgiWeb.SensorLive.Show do
  use KorgiWeb, :live_view

  require Logger

  alias Korgi.Sensors
  alias Korgi.MQTT
  alias Korgi.Sensors.Reading

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    sensor = Sensors.get_sensor!(id) |> Korgi.Repo.preload(:readings)
    broker = MQTT.get_broker_mqtt!(sensor.broker_id)

    if connected?(socket) do
      :timer.send_interval(1000, self(), {:update_chart, sensor})
    end

    story_points =
      sensor.readings
      |> Enum.map(fn %Reading{value: val, inserted_at: time} ->
        %{label: sensor.name, date: time, value: val}
      end)

    {:noreply,
     socket
     |> push_event("story-points", %{data: story_points})
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sensor, sensor)
     |> assign(:readings, sensor.readings)
     |> assign(:broker, broker)}
  end

  @impl true
  def handle_event("toggle_sensor_state", %{"sensorid" => id}, socket) do
    try do
      {sensor_id, ""} = Integer.parse(id)
      sensor = Sensors.get_sensor!(sensor_id)
      Sensors.update_sensor(sensor, %{enabled: not sensor.enabled})
      sensor = Sensors.get_sensor!(id) |> Korgi.Repo.preload(:readings)
      broker = MQTT.get_broker_mqtt!(sensor.broker_id)

      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:sensor, sensor)
       |> assign(:readings, sensor.readings)
       |> assign(:broker, broker)}
    rescue
      e ->
        Logger.error("Handle event error: #{inspect(e)}", [
          :application,
          :mfa
        ])
    end
  end

  @impl Phoenix.LiveView
  def handle_info({:update_chart, sensor}, socket) do
    {:noreply,
     push_event(socket, "new-point", %{
       label: sensor.name,
       date: DateTime.utc_now() |> DateTime.add(Enum.random(1000..15_000_000_000)),
       value: Enum.random(50..150)
     })}
  end

  defp page_title(:show), do: "Show Sensor"
  defp page_title(:edit), do: "Edit Sensor"
end
