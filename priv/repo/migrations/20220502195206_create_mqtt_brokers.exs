defmodule Korgi.Repo.Migrations.CreateMqttBrokers do
  use Ecto.Migration

  def change do
    create table(:mqtt_brokers) do
      add :name, :string
      add :host, :string
      add :port, :integer
      add :username, :string
      add :password, :string

      timestamps()
    end
  end
end
