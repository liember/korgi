defmodule Korgi.MQTTTest do
  use Korgi.DataCase

  alias Korgi.MQTT

  describe "mqtt_brokers" do
    alias Korgi.MQTT.Broker

    import Korgi.MQTTFixtures

    @invalid_attrs %{host: nil, name: nil, password: nil, port: nil, username: nil}

    test "list_mqtt_brokers/0 returns all mqtt_brokers" do
      broker = broker_fixture()
      assert MQTT.list_mqtt_brokers() == [broker]
    end

    test "get_broker!/1 returns the broker with given id" do
      broker = broker_fixture()
      assert MQTT.get_broker!(broker.id) == broker
    end

    test "create_broker/1 with valid data creates a broker" do
      valid_attrs = %{
        host: "some host",
        name: "some name",
        password: "some password",
        port: 42,
        username: "some username"
      }

      assert {:ok, %Broker{} = broker} = MQTT.create_broker(valid_attrs)
      assert broker.host == "some host"
      assert broker.name == "some name"
      assert broker.password == "some password"
      assert broker.port == 42
      assert broker.username == "some username"
    end

    test "create_broker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MQTT.create_broker(@invalid_attrs)
    end

    test "update_broker/2 with valid data updates the broker" do
      broker = broker_fixture()

      update_attrs = %{
        host: "some updated host",
        name: "some updated name",
        password: "some updated password",
        port: 43,
        username: "some updated username"
      }

      assert {:ok, %Broker{} = broker} = MQTT.update_broker(broker, update_attrs)
      assert broker.host == "some updated host"
      assert broker.name == "some updated name"
      assert broker.password == "some updated password"
      assert broker.port == 43
      assert broker.username == "some updated username"
    end

    test "update_broker/2 with invalid data returns error changeset" do
      broker = broker_fixture()
      assert {:error, %Ecto.Changeset{}} = MQTT.update_broker(broker, @invalid_attrs)
      assert broker == MQTT.get_broker!(broker.id)
    end

    test "delete_broker/1 deletes the broker" do
      broker = broker_fixture()
      assert {:ok, %Broker{}} = MQTT.delete_broker(broker)
      assert_raise Ecto.NoResultsError, fn -> MQTT.get_broker!(broker.id) end
    end

    test "change_broker/1 returns a broker changeset" do
      broker = broker_fixture()
      assert %Ecto.Changeset{} = MQTT.change_broker(broker)
    end
  end
end
