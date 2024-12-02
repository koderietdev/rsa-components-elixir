defmodule RsaComponents.BulkActions do
  use RsaComponents, :component

  attr :class, :string, default: nil
  attr :selected, :integer, required: true
  attr :total, :integer, required: true
  attr :show, :boolean, default: false

  slot :action, required: true

  def bulk_actions_bar(assigns) do
    ~H"""
    <div class={
      classes([
        "invisible min-w-80 sm:w-[50vw] right-0 left-0 md:m-auto right-2 left-2 bottom-2 py-1 px-5 flex flex-1 flex-row bg-neutral-950 rounded-lg",
        @show && "fixed visible",
        @class
      ])
    }>
      <div class="flex-1 content-center text-neutral-400 text-sm">
        <span class="text-white font-bold"><%= @selected %></span>
        of <span class="text-white font-bold"><%= @total %></span>
        selected
      </div>
      <div class="flex flex-1 justify-end text-sm">
        <%= render_slot(@action) %>
      </div>
    </div>
    """
  end
end
