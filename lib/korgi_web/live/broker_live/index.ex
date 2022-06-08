defmodule KorgiWeb.BrokerLive.Index do
  use KorgiWeb, :live_view

  alias Korgi.MQTT.Broker
  alias Korgi.MQTT

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:brokers, MQTT.list_mqtt_brokers())
     |> assign(%{changeset: MQTT.change_broker_mqtt(%Broker{})})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sensors")
    |> assign(:sensor, nil)
  end

  @impl true
  def handle_event("delete", %{"brokerid" => id}, socket) do
    with {id, ""} <- Integer.parse(id) do
      MQTT.get_broker_mqtt!(id)
      |> MQTT.delete_broker_mqtt()

      {:noreply,
       socket
       |> put_flash(:info, "Broker deleted")
       |> assign(:brokers, MQTT.list_mqtt_brokers())}
    end
  end

  def handle_event("validate", %{"broker" => params}, socket) do
    changeset =
      %Broker{}
      |> MQTT.change_broker_mqtt(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"broker" => params}, socket) do
    case MQTT.create_broker_mqtt(params) do
      {:ok, broker} ->
        MQTT.Connection.connect(broker)

        {:noreply,
         socket
         |> put_flash(:info, "user created")
         |> assign(:brokers, MQTT.list_mqtt_brokers())}

      #       |> redirect(to: Routes.user_path(MyAppWeb.Endpoint, MyAppWeb.User.ShowView, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset) |> put_flash(:error, "wrong")}
    end
  end
end
