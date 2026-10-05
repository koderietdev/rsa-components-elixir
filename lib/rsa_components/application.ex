defmodule RsaComponents.Application do
  @moduledoc false
  use Application

  # TwMerge caches merged class strings in an ETS table owned by this process.
  # Starting it here means every app that depends on rsa_components gets it
  # for free, without touching its own supervision tree.
  @impl true
  def start(_type, _args) do
    Supervisor.start_link([TwMerge.Cache], strategy: :one_for_one, name: RsaComponents.Supervisor)
  end
end
