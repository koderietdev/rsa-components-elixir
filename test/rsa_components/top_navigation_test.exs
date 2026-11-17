defmodule RsaComponents.TopNavigationTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest

  defp render_nav(assigns) do
    ~H"""
    <RsaComponents.TopNavigation.top_navigation title="Vehicles" current_user={nil}>
      <:menu_item path="/admin">Dashboard</:menu_item>
      <:menu_item path="/admin/cars">Cars</:menu_item>
    </RsaComponents.TopNavigation.top_navigation>
    """
    |> rendered_to_string()
  end

  defp render_nav_without_items(assigns) do
    ~H"""
    <RsaComponents.TopNavigation.top_navigation title="Vehicles" current_user={nil} />
    """
    |> rendered_to_string()
  end

  defp render_nav_with_dropdown(assigns) do
    ~H"""
    <RsaComponents.TopNavigation.top_navigation title="Vehicles" current_user={nil}>
      <:menu_item path="/admin">Dashboard</:menu_item>
      <:menu_dropdown id="country-menu" label="Country">
        <button>Norway</button>
      </:menu_dropdown>
    </RsaComponents.TopNavigation.top_navigation>
    """
    |> rendered_to_string()
  end

  defp class_of(node), do: node |> Floki.attribute("class") |> List.first()

  test "menu items sit in the header from md up and are hidden on phones" do
    header_links = render_nav(%{}) |> Floki.parse_fragment!() |> Floki.find("header nav a")

    assert length(header_links) == 2

    for link <- header_links do
      assert class_of(link) =~ "hidden"
      assert class_of(link) =~ "md:inline"
    end
  end

  test "the drawer repeats the menu items for phones, before the cross-app links" do
    drawer_links = render_nav(%{}) |> Floki.parse_fragment!() |> Floki.find("#drawer nav a")

    assert [first, second | cross_app] = drawer_links
    assert Floki.text(first) =~ "Dashboard"
    assert Floki.attribute(first, "href") == ["/admin"]
    assert class_of(first) =~ "md:hidden"
    assert Floki.text(second) =~ "Cars"
    assert Enum.any?(cross_app, &(Floki.text(&1) =~ "Users Admin"))
  end

  test "without menu items the header nav and the drawer carry no app links" do
    doc = render_nav_without_items(%{}) |> Floki.parse_fragment!()

    assert Floki.find(doc, "header nav a") == []

    refute doc
           |> Floki.find("#drawer nav a")
           |> Enum.any?(&(Floki.attribute(&1, "href") == ["/admin"]))
  end

  test "a dropdown is a button in the header that opens its list, closed to begin with" do
    doc = render_nav_with_dropdown(%{}) |> Floki.parse_fragment!()

    assert [button] = Floki.find(doc, "header nav button[aria-controls=country-menu-list]")
    assert Floki.text(button) =~ "Country"
    assert Floki.attribute(button, "phx-click") != []
    assert Floki.attribute(button, "aria-expanded") == ["false"]

    # The chevron tells it apart from the links beside it.
    assert [_chevron] = Floki.find(button, "svg#country-menu-chevron")

    assert [list] = Floki.find(doc, "header nav #country-menu-list")
    assert class_of(list) =~ "hidden"
    assert Floki.text(list) =~ "Norway"
    assert Floki.attribute(list, "phx-click-away") != []
  end

  test "the drawer shows a dropdown as an open list on phones, after the menu items" do
    doc = render_nav_with_dropdown(%{}) |> Floki.parse_fragment!()

    assert [group] = Floki.find(doc, "#drawer nav > div")
    assert class_of(group) =~ "md:hidden"
    assert Floki.text(group) =~ "Country"
    assert Floki.text(group) =~ "Norway"
  end

  test "without a dropdown the menu has none" do
    doc = render_nav(%{}) |> Floki.parse_fragment!()

    assert Floki.find(doc, "header nav button") == []
    assert Floki.find(doc, "#drawer nav > div") == []
  end
end
