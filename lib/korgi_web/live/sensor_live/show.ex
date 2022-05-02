defmodule KorgiWeb.SensorLive.Show do
  use KorgiWeb, :live_view

  require Logger

  alias Korgi.Sensors
  alias Korgi.MQTT

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update_chart)
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    sensor = Sensors.get_sensor!(id) |> Korgi.Repo.preload(:readings)
    broker = MQTT.get_broker_mqtt!(sensor.broker_id)

    {:noreply,
     socket
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
  def handle_info(:update_chart, socket) do
    {:noreply,
     Enum.reduce(1..5, socket, fn i, acc ->
       push_event(
         acc,
         "new-point",
         %{label: "User #{i}", value: Enum.random(50..150) + i * 10}
       )
     end)}
  end

  defp page_title(:show), do: "Show Sensor"
  defp page_title(:edit), do: "Edit Sensor"
end
