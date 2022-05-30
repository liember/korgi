defmodule Korgi.Repo.Migrations.AddSensorType do
  use Ecto.Migration

  def change do
    alter table(:sensors) do
      add :type, :string
    end
  end
end
