defmodule RsaComponents.Table do
  use RsaComponents, :component

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  attr :actions_title, :string, default: "Actions", doc: "the title for the last column"

  slot :col, required: true do
    attr(:label, :string)
  end

  slot(:action, doc: "the slot for showing user actions in the last table column")

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <.table_header>
          <.table_row is_header={false}>
            <.table_head :for={col <- @col} class="w-[100px]">
              <%= col[:label] %>
            </.table_head>
            <.table_head class="w-14">
              <span class="sr-only"><%= @actions_title %></span>
            </.table_head>
          </.table_row>
        </.table_header>

        <.table_body id={@id} rows={@rows}>
          <.table_row :for={row <- @rows} id={@row_id && @row_id.(row)}>
            <.table_cell
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={[@row_click && "hover:cursor-pointer"]}
            >
              <span class={[i == 0 && "font-semibold text-zinc-900"]}>
                <%= render_slot(col, @row_item.(row)) %>
              </span>
            </.table_cell>
            <.table_cell if={@action != []} class="w-14 p-0">
              <div class="relative whitespace-nowrap w-14 text-right text-sm font-medium pr-2">
                <span
                  :for={action <- @action}
                  class="ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </.table_cell>
          </.table_row>
        </.table_body>
      </table>
    </div>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_header(assigns) do
    ~H"""
    <thead
      class={
        classes(["[&_tr]:border-b bg-neutral-25 text-sm  py-2 px-4 font-bold font-normal", @class])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </thead>
    """
  end

  attr(:class, :string, default: nil)
  attr(:is_header, :boolean, default: false)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_row(assigns) do
    ~H"""
    <tr
      class={
        classes([
          "border-b transition-colors text-sm hover:bg-muted/50 data-[state=selected]:bg-muted",
          ["relative p-0 group", !@is_header && "hover:bg-neutral-25"],
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_head(assigns) do
    ~H"""
    <th
      class={
        classes([
          "h-12 px-3 py-5 text-left align-middle font-bold text-muted-foreground [&:has([role=checkbox])]:pr-0",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  attr(:id, :string, required: true)
  attr(:rows, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_body(assigns) do
    ~H"""
    <tbody
      id={@id}
      phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
      class={classes(["[&_tr:last-child]:border-0", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tbody>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_cell(assigns) do
    ~H"""
    <td class={classes(["px-3 py-5 align-middle [&:has([role=checkbox])]:pr-0", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  @doc """
  Render table footer
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))
  slot(:inner_block, required: true)

  def table_footer(assigns) do
    ~H"""
    <div
      class={
        classes([
          "border-t bg-muted/50 font-medium [&>tr]:last:border-b-0",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_caption(assigns) do
    ~H"""
    <caption class={classes(["mt-4 text-sm text-muted-foreground", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </caption>
    """
  end
end
