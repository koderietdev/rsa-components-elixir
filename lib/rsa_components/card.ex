defmodule RsaComponents.Card do
  use RsaComponents, :component

  attr :fixed_height, :boolean, default: false
  attr :class, :string, default: nil

  slot :header do
    attr :class, :string
  end

  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={
      classes([
        "flex flex-1 flex-col bg-white shadow-sm rounded-xl p-8",
        @fixed_height && "h-[248px] justify-between",
        length(@header) > 0 && "p-0",
        @class
      ])
    }>
      <%= for header <- @header do %>
        <div class={classes(["px-10 py-8 font-bold border-b border-b-neutral-50", header[:class]])}>
          <%= render_slot(@header) %>
        </div>
      <% end %>
      <div class="px-10 py-3">
        <%= render_slot(@inner_block) %>
      </div>
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
    <div class={
      classes([
        "flex flex-1 flex-col bg-white shadow-sm rounded-xl p-8",
        @fixed_height && "h-[248px] justify-between",
        @class
      ])
    }>
      <span class="text-xl font-bold"><%= @title %></span>
      <div class={[
        "text-5xl font-semibold",
        @number == 0 && "text-neutral-100",
        @number > 0 && "text-brand-500"
      ]}>
        <%= @number %>
      </div>
    </div>
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

  slot :header do
    attr :class, :string
  end

  slot :item, doc: "List items to render in the card" do
    attr(:title, :string)
  end

  slot :empty_list, doc: "Slot to render when the list is empty"

  def list_card(assigns) do
    ~H"""
    <div class={
      classes([
        "flex flex-1 flex-col bg-white shadow-sm rounded-xl p-8",
        length(@header) > 0 && "p-0",
        @class
      ])
    }>
      <%= for header <- @header do %>
        <div class={classes(["px-10 py-8 font-bold border-b border-b-neutral-50", header[:class]])}>
          <%= render_slot(@header) %>
        </div>
      <% end %>
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
    </div>
    """
  end
end
