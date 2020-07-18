defmodule Nobinalo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Nobinalo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Nobinalo.PubSub}
      # Start a worker by calling: Nobinalo.Worker.start_link(arg)
      # {Nobinalo.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Nobinalo.Supervisor)
  end
end
