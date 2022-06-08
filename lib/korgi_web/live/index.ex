defmodule KorgiWeb.Live.Index do
  use KorgiWeb, :live_view

  alias Korgi.Sensors
  alias Korgi.MQTT

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, b_count: MQTT.count_mqqt_brokers())
     |> assign(s_count: Sensors.count())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Korgi")
    |> assign(:sensor, nil)
  end
end
