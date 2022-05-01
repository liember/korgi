defmodule Korgi.Repo.Migrations.CreateReadings do
  use Ecto.Migration

  def change do
    create table(:readings) do
      add :sensor_id, references(:sensors, on_delete: :delete_all)
      add :value, :string

      timestamps()
    end
  end
end
