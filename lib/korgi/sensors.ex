defmodule Korgi.Sensors do
  @moduledoc """
  The Sensors context.
  """

  import Ecto.Query, warn: false
  alias Korgi.Repo

  alias Korgi.Sensors.Reading
  alias Korgi.Sensors.Sensor

  def sensor_pubsub_topic(sensor) do
    "sensor/" <> (sensor.id |> to_string())
  end

  @doc """
  Returns the list of sensors.

  ## Examples

      iex> list_sensors()
      [%Sensor{}, ...]

  """
  def list_sensors do
    Repo.all(Sensor)
  end

  def count do
    Repo.one(from p in "sensors", select: count(p.id))
  end

  @doc """
  Gets a single sensor.

  Raises `Ecto.NoResultsError` if the Sensor does not exist.

  ## Examples

      iex> get_sensor!(123)
      %Sensor{}

      iex> get_sensor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sensor!(id), do: Repo.get!(Sensor, id)

  def get_sensor_id_by_topic!(topic) do
    query =
      from u in "sensors",
        where: u.topic == ^topic,
        select: u.id

    Repo.one!(query)
  end

  @doc """
  Creates a sensor.

  ## Examples

      iex> create_sensor(%{field: value})
      {:ok, %Sensor{}}

      iex> create_sensor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sensor(attrs \\ %{}) do
    %Sensor{}
    |> Sensor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sensor.

  ## Examples

      iex> update_sensor(sensor, %{field: new_value})
      {:ok, %Sensor{}}

      iex> update_sensor(sensor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sensor(%Sensor{} = sensor, attrs) do
    sensor
    |> Sensor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sensor.

  ## Examples

      iex> delete_sensor(sensor)
      {:ok, %Sensor{}}

      iex> delete_sensor(sensor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sensor(%Sensor{} = sensor) do
    Repo.delete(sensor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sensor changes.

  ## Examples

      iex> change_sensor(sensor)
      %Ecto.Changeset{data: %Sensor{}}

  """
  def change_sensor(%Sensor{} = sensor, attrs \\ %{}) do
    Sensor.changeset(sensor, attrs)
  end

  @doc """
  Returns the list of readings.

  ## Examples

      iex> list_readings()
      [%Reading{}, ...]

  """
  def list_readings do
    Repo.all(Reading)
  end

  @doc """
  Gets a single reading.

  Raises `Ecto.NoResultsError` if the Reading does not exist.

  ## Examples

      iex> get_reading!(123)
      %Reading{}

      iex> get_reading!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reading!(id), do: Repo.get!(Reading, id)

  @doc """
  Creates a reading.

  ## Examples

      iex> create_reading(%{field: value})
      {:ok, %Reading{}}

      iex> create_reading(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reading(attrs \\ %{}) do
    %Reading{}
    |> Reading.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reading.

  ## Examples

      iex> update_reading(reading, %{field: new_value})
      {:ok, %Reading{}}

      iex> update_reading(reading, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reading(%Reading{} = reading, attrs) do
    reading
    |> Reading.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reading.

  ## Examples

      iex> delete_reading(reading)
      {:ok, %Reading{}}

      iex> delete_reading(reading)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reading(%Reading{} = reading) do
    Repo.delete(reading)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reading changes.

  ## Examples

      iex> change_reading(reading)
      %Ecto.Changeset{data: %Reading{}}

  """
  def change_reading(%Reading{} = reading, attrs \\ %{}) do
    Reading.changeset(reading, attrs)
  end
end
