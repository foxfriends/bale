defmodule BaleWeb.ErrorJSONTest do
  use BaleWeb.ConnCase, async: true

  test "renders 401" do
    assert BaleWeb.ErrorJSON.render("401.json", %{}) == %{errors: %{detail: "Unauthorized"}}
  end

  test "renders 403" do
    assert BaleWeb.ErrorJSON.render("403.json", %{}) == %{errors: %{detail: "Forbidden"}}
  end

  test "renders 404" do
    assert BaleWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 409" do
    assert BaleWeb.ErrorJSON.render("409.json", %{}) == %{errors: %{detail: "Conflict"}}
  end

  test "renders 500" do
    assert BaleWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
