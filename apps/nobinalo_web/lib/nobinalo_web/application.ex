defmodule NobinaloWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NobinaloWeb.Telemetry,
      # Start the Endpoint (http/https)
      NobinaloWeb.Endpoint
      # Start a worker by calling: NobinaloWeb.Worker.start_link(arg)
      # {NobinaloWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NobinaloWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NobinaloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
