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
end
