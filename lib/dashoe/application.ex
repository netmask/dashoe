defmodule Dashoe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Dashoe.Repo,
      # Start the Telemetry supervisor
      DashoeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dashoe.PubSub},
      # Start the Endpoint (http/https)
      DashoeWeb.Endpoint,
      Dashoe.InventorySocketClient
      # Start a worker by calling: Dashoe.Worker.start_link(arg)
      # {Dashoe.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dashoe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DashoeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
