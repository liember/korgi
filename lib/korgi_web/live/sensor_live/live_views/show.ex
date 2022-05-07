defmodule KorgiWeb.SensorLive.Show do
  use KorgiWeb, :live_view

  require Logger

  alias Korgi.Sensors
  alias Korgi.MQTT
  alias Korgi.Sensors.Reading
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    try do
      sensor = Sensors.get_sensor!(id) |> Korgi.Repo.preload(:readings)
      broker = MQTT.get_broker_mqtt!(sensor.broker_id)
      PubSub.subscribe(Korgi.PubSub, Sensors.sensor_pubsub_topic(sensor))

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
    rescue
      e ->
        Logger.error("Error while init show_live: #{inspect(e)}")
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("toggle_sensor_state", %{"sensorid" => id}, socket) do
      with {sensor_id, ""} <- Integer.parse(id),
           sensor <- Sensors.get_sensor!(sensor_id),
           {:ok, updated} <- Sensors.update_sensor(sensor, %{enabled: not sensor.enabled}) do
        {
          :noreply, socket
          |> assign(:sensor, updated)
          |> put_flash(:info, "Sensor " <> if sensor.enabled do "disabled" else "enabled" end <> " updated successfully")
        }
      end
  end

  @impl true
  def handle_info({:sensor_new_reading, %{reading: reading, label: label}}, socket) do
    Logger.info("Update sensor data: #{inspect(reading.value)}")

    {:noreply,
     push_event(socket, "new-point", %{
       label: label,
       value: reading.value,
       date: reading.updated_at
     })}
  end

  defp page_title(:show), do: "Show Sensor"
  defp page_title(:edit), do: "Edit Sensor"
end
