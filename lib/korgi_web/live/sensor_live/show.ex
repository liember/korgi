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
    if connected?(socket) do
      :timer.send_interval(10000, {:update, id})
    end

    assign_page_data(socket, id)
  end

  @impl true
  def handle_event("toggle_sensor_state", %{"sensorid" => id}, socket) do
    try do
      with {sensor_id, ""} <- Integer.parse(id),
           sensor <- Sensors.get_sensor!(sensor_id),
           {:ok, updated} <- Sensors.update_sensor(sensor, %{enabled: not sensor.enabled}) do
        {:noreply, socket |> assign(:sensor, updated)}
      end
    rescue
      e -> Logger.error("Handle event error: #{inspect(e)}")
    end
  end

  @impl true
  def handle_info({:update, id}, socket) do
    assign_page_data(socket, id)
  end

  defp assign_page_data(socket, id) do
    sensor = Sensors.get_sensor!(id) |> Korgi.Repo.preload(:readings)
    broker = MQTT.get_broker_mqtt!(sensor.broker_id)

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

  defp page_title(:show), do: "Show Sensor"
  defp page_title(:edit), do: "Edit Sensor"
end
