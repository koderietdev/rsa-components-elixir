defmodule RsaComponents.CoreComponents do
  use RsaComponents, :component

  @link_default "#1A2BAD"

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-brand-600 hover:bg-brand-500 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from your `assets/vendor/heroicons` directory and bundled
  within your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  def show_drawer(selector, display \\ "block") do
    JS.show(
      to: selector,
      display: display,
      transition: {"ease-out duration-150", "translate-x-full", "translate-x-0"},
      time: 150
    )
    |> JS.show(
      to: "#{selector}-backdrop",
      transition: {"ease-in duration-150", "opacity-0", "opacity-110"},
      time: 150
    )
  end

  def hide_drawer(selector) do
    JS.hide(
      to: selector,
      transition: {"ease-in duration-150", "translate-x-0", "translate-x-full"},
      time: 150
    )
    |> JS.hide(
      to: "#{selector}-backdrop",
      transition: {"ease-in duration-150", "opacity-100", "opacity-0"},
      time: 150
    )
  end
end
