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
  "sensors",
  [
    [
      name: "lm3244",
      topic: "boilerroom/1",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    ],
    [
      name: "lm3244",
      topic: "boilerroom/2",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    ]
  ]
)

Korgi.Repo.insert_all(
  "readings",
  [
    [
      value: "25",
      sensor_id: Korgi.Sensors.get_sensor!(1).id,
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    ],
    [
      value: "26",
      sensor_id: Korgi.Sensors.get_sensor!(1).id,
      inserted_at: DateTime.utc_now() |> DateTime.add(60, :second),
      updated_at: DateTime.utc_now() |> DateTime.add(60, :second)
    ],
    [
      value: "28",
      sensor_id: Korgi.Sensors.get_sensor!(1).id,
      inserted_at: DateTime.utc_now() |> DateTime.add(120, :second),
      updated_at: DateTime.utc_now() |> DateTime.add(120, :second)
    ],
    [
      value: "20",
      sensor_id: Korgi.Sensors.get_sensor!(1).id,
      inserted_at: DateTime.utc_now() |> DateTime.add(180, :second),
      updated_at: DateTime.utc_now() |> DateTime.add(180, :second)
    ]
  ]
)
