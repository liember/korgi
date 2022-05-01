defmodule Korgi.Repo.Migrations.CreateSensors do
  use Ecto.Migration

  def change do
    create table(:sensors) do
      add :name, :string
      add :topic, :string

      timestamps()
    end
  end
end
