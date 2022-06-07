defmodule KorgiWeb.SensorLive.Index do
  use KorgiWeb, :live_view

  alias Korgi.Sensors
  alias Korgi.Sensors.Sensor

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :sensors, list_sensors())
     |> assign(%{changeset: Sensors.change_sensor(%Sensor{})})}
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

  @impl true
  def handle_event("toggle_sensor_state", %{"sensorid" => id}, socket) do
    try do
      {sensor_id, ""} = Integer.parse(id)
      %Sensor{enabled: state} = sensor = Sensors.get_sensor!(sensor_id)
      IO.inspect({sensor, not state})
      IO.inspect(Sensors.update_sensor(sensor, %{enabled: not state}))
    rescue
      e -> IO.inspect(e)
    end

    {:noreply, assign(socket, :sensors, list_sensors())}
  end

  def handle_event("validate", %{"sensor" => params}, socket) do
    changeset =
      %Sensor{}
      |> Sensors.change_sensor(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"sensor" => sensor_params}, socket) do
    case Sensors.create_sensor(sensor_params) do
      {:ok, _} ->
        {:noreply, socket |> put_flash(:info, "user created")}

      #       |> redirect(to: Routes.user_path(MyAppWeb.Endpoint, MyAppWeb.User.ShowView, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset) |> put_flash(:error, "wrong")}
    end
  end

  ## TODO sort by name or other prams (no by update date)
  defp list_sensors do
    Sensors.list_sensors()
  end
end
