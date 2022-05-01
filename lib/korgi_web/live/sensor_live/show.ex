defmodule KorgiWeb.SensorLive.Show do
  use KorgiWeb, :live_view

  alias Korgi.Sensors

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sensor, Sensors.get_sensor!(id))}
  end

  defp page_title(:show), do: "Show Sensor"
  defp page_title(:edit), do: "Edit Sensor"
end
