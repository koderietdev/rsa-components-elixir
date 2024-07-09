defmodule RsaComponents.CoreComponents do
  use RsaComponents, :component

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
