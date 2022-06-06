defmodule Korgi.MQTT do
  @moduledoc """
  The MQTT context.
  """

  import Ecto.Query, warn: false
  alias Korgi.Repo

  alias Korgi.MQTT.Broker

  @doc """
  Returns the list of mqtt_brokers.

  ## Examples

      iex> list_mqtt_brokers()
      [%Broker{}, ...]

  """
  def list_mqtt_brokers do
    Repo.all(Broker)
  end

  @doc """
  Gets a single broker_mqtt.

  Raises `Ecto.NoResultsError` if the Broker mqtt does not exist.

  ## Examples

      iex> get_broker_mqtt!(123)
      %Broker{}

      iex> get_broker_mqtt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_broker_mqtt!(id), do: Repo.get!(Broker, id)

  @doc """
  Creates a broker_mqtt.

  ## Examples

      iex> create_broker_mqtt(%{field: value})
      {:ok, %Broker{}}

      iex> create_broker_mqtt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_broker_mqtt(attrs \\ %{}) do
    %Broker{}
    |> Broker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a broker_mqtt.

  ## Examples

      iex> update_broker_mqtt(broker_mqtt, %{field: new_value})
      {:ok, %Broker{}}

      iex> update_broker_mqtt(broker_mqtt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_broker_mqtt(%Broker{} = broker_mqtt, attrs) do
    broker_mqtt
    |> Broker.changeset(attrs)
    |> Repo.update()
  end


  def get_mqqtt_broker_id_by_name!(name) do
    query = from u in "mqtt_brokers",
          where: u.name == ^name,
          select: u.id
    Repo.all(query)
  end

  @doc """
  Deletes a broker_mqtt.

  ## Examples

      iex> delete_broker_mqtt(broker_mqtt)
      {:ok, %Broker{}}

      iex> delete_broker_mqtt(broker_mqtt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_broker_mqtt(%Broker{} = broker_mqtt) do
    Repo.delete(broker_mqtt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking broker_mqtt changes.

  ## Examples

      iex> change_broker_mqtt(broker_mqtt)
      %Ecto.Changeset{data: %Broker{}}

  """
  def change_broker_mqtt(%Broker{} = broker_mqtt, attrs \\ %{}) do
    Broker.changeset(broker_mqtt, attrs)
  end
end
