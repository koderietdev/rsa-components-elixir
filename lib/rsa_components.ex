defmodule RsaComponents do
  @moduledoc false
  def component do
    quote do
      use Phoenix.Component

      import Tails, only: [classes: 1]

      alias Phoenix.LiveView.JS
    end
  end

  def flop_table_classes do
    [
      thead_attrs: [
        class: "[&_tr]:border-b bg-[#F8F9FD] text-sm  py-2 px-4 font-bold font-normal"
      ],
      tbody_attrs: [class: "[&_tr]:border-b text-sm [&_tr:last-child]:border-0"],
      tr_attrs: [class: "hover:bg-[#F8F9FD]"],
      thead_th_attrs: [
        class:
          "h-12 px-3 py-5 text-left align-middle font-bold text-muted-foreground [&:has([role=checkbox])]:pr-0"
      ],
      tbody_tr: [
        class: [
          "border-b transition-colors text-sm hover:bg-muted/50 data-[state=selected]:bg-muted",
          ["relative p-0 group", "hover:bg-[#F8F9FD]"]
        ]
      ],
      tbody_td_attrs: [
        class: ["px-1 py-3 align-middle [&:has([role=checkbox])]:pr-0", ["lg:px-3 lg:py-5"]]
      ]
    ]
  end

  @doc """
  When used, dispatch to the appropriate macro.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
