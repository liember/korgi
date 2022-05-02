defmodule Korgi.Repo.Migrations.AddSensorState do
  use Ecto.Migration

  def change do
    alter table(:sensors) do
      add :enabled, :boolean, default: false, null: false
    end
  end
end
