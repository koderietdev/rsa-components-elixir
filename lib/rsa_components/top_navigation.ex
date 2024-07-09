defmodule RsaComponents.TopNavigation do
  use RsaComponents, :component

  import RsaComponents.CoreComponents

  def top_navigation(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-16">
      <div class="flex items-center py-4">
        <div class="flex-0 items-center gap-4">
          <.link navigate="/admin">
            <.logo class="h-10" />
          </.link>
        </div>
        <nav class="flex w-full pl-10 py-2 gap-10 justify-end">
          <.link
            navigate="/admin/inquiries"
            class="font-medium leading-6 hover:text-zinc-700 hover:underline"
          >
            Leads
          </.link>
          <.link
            navigate="/admin/recipient-groups"
            class="font-medium leading-6 hover:text-zinc-700 hover:underline"
          >
            Recipient Groups
          </.link>
          <.link
            navigate="/admin/pages"
            class="font-medium leading-6 hover:text-zinc-700 hover:underline"
          >
            Pages
          </.link>
          <div class="cursor-pointer" phx-click={show_drawer("#drawer", "flex")}>
            <.menu_icon />
          </div>
        </nav>
      </div>
    </header>
    <.drawer />
    """
  end

  def drawer(assigns) do
    ~H"""
    <div
      id="drawer"
      class="hidden w-[480px] flex-col py-5 px-16 z-40 absolute right-0 h-screen top-0 bg-white"
    >
      <div class="flex justify-end h-14">
        <button class="" phx-click={hide_drawer("#drawer")}>
          <.icon name="hero-x-mark-solid" class="w-7 h-7" />
        </button>
      </div>
      <div id="drawer-content" class="w-full">
        <nav class="flex flex-col">
          <.drawer_link href="https://auth.rsa-dev.com/admin/">
            Auth Admin
          </.drawer_link>
          <.drawer_link href="https://marketing.rsa-dev.com/admin/">
            Marketing Admin
          </.drawer_link>
          <.drawer_link href="https://infoweb.rsa-dev.com/admin">
            Infoweb Admin
          </.drawer_link>
        </nav>
      </div>
    </div>
    <div id="drawer-backdrop" class="hidden bg-black/50 dark:bg-black/80 fixed inset-0 z-30" />
    """
  end

  attr :href, :string
  slot :inner_block, required: true

  defp drawer_link(assigns) do
    ~H"""
    <.link
      href={@href}
      class="py-5 text-lg font-medium leading-6 border-b border-[#EEEEF3] hover:text-zinc-700 hover:underline"
      target="_blank"
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  attr :class, :string

  defp logo(assigns) do
    ~H"""
    <svg
      class={@class}
      version="1.1"
      id="Layer_1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      x="0"
      y="0"
      viewBox="0 0 260.6 111.2"
      style="enable-background:new 0 0 260.6 111.2"
      xml:space="preserve"
    >
      <style>
        .st1{clip-path:url(#SVGID_00000141436110902655703650000006298701010020589491_);fill:#fff}
      </style>
      <path style="fill:#1a1ab6" d="M0 0h260.6v111.2H0z" />
      <defs><path id="SVGID_1_" d="M0 0h260.6v111.2H0z" /></defs>
      <clipPath id="SVGID_00000098206489256643427130000009073784550274316196_">
        <use xlink:href="#SVGID_1_" style="overflow:visible" />
      </clipPath>
      <path
        style="clip-path:url(#SVGID_00000098206489256643427130000009073784550274316196_);fill:#fff"
        d="M90.2 47.3c0-12.4-8-16.5-20.9-16.5H34.6v49.6H49V63.9h14.3l10.6 16.5h16.4L79 62.8c6.1-1.6 11.2-5.7 11.2-15.5m-21.5 5.6H49V42.5h19.8c5 0 7.2 1.3 7.2 5.2-.1 3.9-2.2 5.2-7.3 5.2m88 11.3c0 10.6-6.1 17.1-29.5 17.1-21.7 0-27.6-7.4-30.1-14l14.9-2.1c1.8 3.2 6 5.1 15.1 5.1 10.2 0 15.4-.6 15.4-4.5 0-3.8-5.3-3.1-17.2-4.3s-26.6-1.8-26.6-15.4 12.8-16.3 27.7-16.3c14.6 0 26.5 4.5 29.5 13.9L141.1 46c-1.2-3.8-7.8-4.9-15.2-4.9-7.4 0-12.9 1-12.9 4 0 3.2 2.7 3.4 15.5 4.2 15.3.9 28.2 2.8 28.2 14.9m27.4-33.4-25.4 49.6h14.6l4.3-8.4h28.2l4.3 8.4H226l-25.3-49.6h-16.6zM183 61.7l8.8-17.4 8.8 17.4H183z"
      />
    </svg>
    """
  end

  defp menu_icon(assigns) do
    ~H"""
    <svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M3.61719 5.9502H24.3839V8.0502H3.61719V5.9502ZM3.61719 12.9502H24.3839V15.0502H3.61719V12.9502ZM11.2005 19.9502H24.3839V22.0502H11.2005V19.9502Z"
        fill="#15161A"
      />
    </svg>
    """
  end
end
