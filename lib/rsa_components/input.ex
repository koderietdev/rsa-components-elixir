defmodule RsaComponents.Input do
  use RsaComponents, :component

  import RsaComponents.CoreComponents
  import LiveSelect

  @gettext Application.compile_env!(:rsa_components, :gettext_module)

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label
      for={@for}
      class={classes(["block text-sm font-semibold leading-6 text-neutral-950", @class])}
    >
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text text-array textarea time url week trix)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
         multiple pattern placeholder readonly required rows size step phx-key phx-keyup phx-keydown
         debounce mode)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div class="flex flex-col w-full h-full justify-center" phx-feedback-for={@name}>
      <label class="flex items-center gap-2 text-sm leading-6 text-fg">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded h-6 w-6 border-border-input text-brand-500 focus:ring-1"
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div class="flex flex-col w-full" phx-feedback-for={@name}>
      <.label class="mb-2" for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="block h-12 w-full rounded-lg border border-border-input bg-white shadow-sm focus:border-border-input-pressed focus:ring-1 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class="flex flex-col w-full" phx-feedback-for={@name}>
      <.label class="mb-2" for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "block w-full rounded-lg text-fg focus:ring-1 sm:text-sm sm:leading-6",
          "min-h-[6rem] phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          @errors == [] && "border-border-input focus:border-border-input-pressed",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "trix"} = assigns) do
    ~H"""
    <div class="flex flex-col w-full" phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <input id={@id} type="hidden" phx-hook="TrixEditor" name={@name} value={@value} />
      <div id="richtext" phx-update="ignore">
        <trix-editor
          input={@id}
          class="trix-content public border rounded-lg border-border-input focus:ring-1 focus:border-border-input-pressed "
        >
        </trix-editor>
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # Using __given__ might be a hacky way to get the original field but it works
  def input(%{type: "text-array", __given__: %{__given__: %{field: field}}} = assigns) do
    assigns =
      assigns
      |> assign(assigns, field: field)
      |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))

    ~H"""
    <div class="flex flex-col w-full" phx-feedback-for={@name}>
      <.label class="mb-2" for={@id}><%= @label %></.label>
      <input
        type="text"
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value("text", @value)}
        class={[
          "block w-full rounded-lg text-fg focus:ring-1 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-border-input phx-no-feedback:focus:border-border-input-pressed",
          @errors == [] && "border-border-input focus:border-border-input-pressed",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "live_select", __given__: %{__given__: %{field: field}}} = assigns) do
    assigns =
      assigns
      |> assign(field: field)

    ~H"""
    <div class="flex flex-col w-full" phx-feedback-for={@name}>
      <.label class="mb-2" for={@id}><%= @label %></.label>
      <.live_select
        field={@field}
        placeholder={@label}
        debounce={120}
        {@rest}
        {live_select_classes()}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div class="flex flex-col w-full" phx-feedback-for={@name}>
      <.label class="mb-2" for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "block h-12 w-full border rounded-lg text-fg focus:ring-1 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-border-input phx-no-feedback:focus:border-border-input-pressed",
          @errors == [] && "border-border-input focus:border-border-input-pressed",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def live_select_classes() do
    %{
      active_option_class: ~W(text-white bg-gray-600),
      available_option_class: ~W(cursor-pointer hover:bg-bg rounded),
      clear_button_class: ~W(cursor-pointer),
      # clear_tag_button_class: ~W(cursor-pointer),
      container_class: ~W(h-full text-black relative),
      dropdown_class: ~W(absolute p-3 rounded-md shadow z-50 bg-white inset-x-0 top-full),
      option_class: ~W(rounded px-4 py-3),
      selected_option_class: ~W(text-gray-400),
      text_input_class:
        ~W(rounded-md text-fg h-12 w-full border border-border-input  disabled:bg-gray-100 disabled:placeholder:text-gray-400 disabled:text-gray-400 pr-6),
      text_input_selected_class: ~W(border-border-input text-gray-600),
      tags_container_class: ~W(flex flex-wrap gap-1 mb-3),
      tag_class:
        ~W(px-2.5 py-2 text-sm rounded-lg bg-bg-brand-subtle border border-border-brand flex)
    }
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(@gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(@gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
