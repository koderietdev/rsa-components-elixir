defmodule RsaComponents.Card do
  use RsaComponents, :component

  attr :fixed_height, :boolean, default: false
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={
      classes([
        "flex flex-1 flex-col  bg-white shadow-sm rounded-xl p-8",
        @fixed_height && "h-[248px] justify-between",
        @class
      ])
    }>
      <%= render_slot(assigns.inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a card with title and number
  """
  attr :title, :string, required: true
  attr :fixed_height, :boolean, default: true
  attr :class, :string, default: nil
  attr :number, :string, required: true

  def number_card(assigns) do
    ~H"""
    <.card class={@class} fixed_height={@fixed_height}>
      <span class="text-xl font-bold"><%= @title %></span>
      <div class={[
        "text-5xl font-semibold",
        @number == 0 && "text-neutral-100"
      ]}>
        <%= @number %>
      </div>
    </.card>
    """
  end

  @doc """
  Renders a card with list
  """
  attr :class, :string, default: nil
  attr :items, :list

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each item before calling the :item slot"

  slot :header, required: true

  slot :item, doc: "List items to render in the card" do
    attr(:title, :string)
  end

  slot :empty_list, doc: "Slot to render when the list is empty"

  def list_card(assigns) do
    ~H"""
    <.card class={classes(["p-0", @class])}>
      <div class="px-10 py-8 text-xl font-bold pb-8 border-b-neutral-50 border-b">
        <%= render_slot(@header) %>
      </div>
      <div class="pb-8 px-10">
        <%= if length(@items) > 0 do %>
          <ul class="">
            <li
              :for={item <- @items}
              class="flex py-5 border-solid border-b border-b-neutral-50 last:border-b-0"
            >
              <%= render_slot(@item, @row_item.(item)) %>
            </li>
          </ul>
        <% else %>
          <%= render_slot(@empty_list) %>
        <% end %>
      </div>
    </.card>
    """
  end
end
