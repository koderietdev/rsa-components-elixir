defmodule RsaComponents.Tailwind do
  @moduledoc """
  Tailwind class merging for the components.

  `classes/1` replaces `Tails.classes/1`: it takes a string or a (nested)
  list of strings, drops `nil` and `false`, and lets a later class win over
  an earlier one in the same Tailwind group, so `["p-4", @class]` can be
  overridden by the caller.
  """

  @doc "Merge Tailwind classes, later classes winning within a group."
  @spec classes(binary() | list()) :: binary()
  def classes(input), do: TwMerge.merge(input)
end
