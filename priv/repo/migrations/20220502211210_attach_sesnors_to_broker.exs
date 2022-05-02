defmodule Korgi.Repo.Migrations.AttachSesnorsToBroker do
  use Ecto.Migration

  def change do
    alter table(:sensors) do
      add :broker_id, references(:mqtt_brokers, on_delete: :delete_all)
    end
  end
end
