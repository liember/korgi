defmodule Korgi.ReadingsTest do
  use Korgi.DataCase

  alias Korgi.Readings

  describe "readings" do
    alias Korgi.Sensors.Reading

    import Korgi.ReadingsFixtures

    @invalid_attrs %{sesnor_id: nil, value: nil}

    test "list_readings/0 returns all readings" do
      reading = reading_fixture()
      assert Readings.list_readings() == [reading]
    end

    test "get_reading!/1 returns the reading with given id" do
      reading = reading_fixture()
      assert Readings.get_reading!(reading.id) == reading
    end

    test "create_reading/1 with valid data creates a reading" do
      valid_attrs = %{sesnor_id: 42, value: "some value"}

      assert {:ok, %Reading{} = reading} = Readings.create_reading(valid_attrs)
      assert reading.sesnor_id == 42
      assert reading.value == "some value"
    end

    test "create_reading/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Readings.create_reading(@invalid_attrs)
    end

    test "update_reading/2 with valid data updates the reading" do
      reading = reading_fixture()
      update_attrs = %{sesnor_id: 43, value: "some updated value"}

      assert {:ok, %Reading{} = reading} = Readings.update_reading(reading, update_attrs)
      assert reading.sesnor_id == 43
      assert reading.value == "some updated value"
    end

    test "update_reading/2 with invalid data returns error changeset" do
      reading = reading_fixture()
      assert {:error, %Ecto.Changeset{}} = Readings.update_reading(reading, @invalid_attrs)
      assert reading == Readings.get_reading!(reading.id)
    end

    test "delete_reading/1 deletes the reading" do
      reading = reading_fixture()
      assert {:ok, %Reading{}} = Readings.delete_reading(reading)
      assert_raise Ecto.NoResultsError, fn -> Readings.get_reading!(reading.id) end
    end

    test "change_reading/1 returns a reading changeset" do
      reading = reading_fixture()
      assert %Ecto.Changeset{} = Readings.change_reading(reading)
    end
  end
end
