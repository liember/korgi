defmodule KorgiWeb.SensorLive.Index do
  use KorgiWeb, :live_view

  alias Korgi.Sensors
  alias Korgi.Sensors.Sensor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :sensors, list_sensors())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sensor")
    |> assign(:sensor, Sensors.get_sensor!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sensor")
    |> assign(:sensor, %Sensor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sensors")
    |> assign(:sensor, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sensor = Sensors.get_sensor!(id)
    {:ok, _} = Sensors.delete_sensor(sensor)

    {:noreply, assign(socket, :sensors, list_sensors())}
  end

  defp list_sensors do
    Sensors.list_sensors()
  end
end
