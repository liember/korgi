defmodule Korgi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Korgi.Repo,
      # Start the Telemetry supervisor
      KorgiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Korgi.PubSub},
      # Start the Endpoint (http/https)
      KorgiWeb.Endpoint
      # Start a worker by calling: Korgi.Worker.start_link(arg)
      # {Korgi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Korgi.Supervisor]
    res = Supervisor.start_link(children, opts)
    Korgi.MQTT.Connection.init(:ok)
    res
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KorgiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
