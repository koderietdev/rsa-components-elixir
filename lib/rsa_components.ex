defmodule RsaComponents do
  @moduledoc false
  def component do
    quote do
      use Phoenix.Component

      import Tails, only: [classes: 1]

      alias Phoenix.LiveView.JS
    end
  end

  @doc """
  When used, dispatch to the appropriate macro.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
