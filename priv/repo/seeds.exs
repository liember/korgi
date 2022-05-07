# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Korgi.Repo.insert!(%Korgi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Korgi.Repo.insert_all(
  "mqtt_brokers",
  [
    [
      host: "localhost",
      name: "home_broker",
      password: "liember",
      port: 1883,
      username: "liember",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    ]
  ]
)

broker_id = Korgi.MQTT.get_broker_mqtt!(1).id

Korgi.Repo.insert_all(
  "sensors",
  [
    [
      name: "lm3244",
      topic: "boilerroom/1",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now(),
      broker_id: broker_id
    ],
    [
      name: "lm3244",
      topic: "boilerroom/2",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now(),
      broker_id: broker_id
    ]
  ]
)

sensor_id = Korgi.Sensors.get_sensor!(1).id

Korgi.Repo.insert_all(
  "readings",
  [
    [
      value: "25",
      sensor_id: sensor_id,
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    ],
    [
      value: "26",
      sensor_id: sensor_id,
      inserted_at: DateTime.utc_now() |> DateTime.add(-60, :second),
      updated_at: DateTime.utc_now() |> DateTime.add(-60, :second)
    ],
    [
      value: "28",
      sensor_id: sensor_id,
      inserted_at: DateTime.utc_now() |> DateTime.add(-120, :second),
      updated_at: DateTime.utc_now() |> DateTime.add(-120, :second)
    ],
    [
      value: "20",
      sensor_id: sensor_id,
      inserted_at: DateTime.utc_now() |> DateTime.add(-180, :second),
      updated_at: DateTime.utc_now() |> DateTime.add(-180, :second)
    ]
  ]
)
