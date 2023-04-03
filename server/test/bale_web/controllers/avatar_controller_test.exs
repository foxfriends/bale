defmodule BaleWeb.AvatarControllerTest do
  use BaleWeb.ConnCase
  import BaleWeb.AuthFixtures
  import BaleWeb.AvatarFixtures

  test "GET /api/avatars/:account_id", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, _} = avatar_fixture(a, 0x00FF00, 50)

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/avatars/#{a}")

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "color" => 0x00FF00,
             "size" => 50
           }
  end

  test "POST /api/avatars/", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/avatars/", %{"color" => 0xFF0000, "size" => 30})

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "color" => 0xFF0000,
             "size" => 30
           }
  end

  test "POST /api/avatars/ (someone else)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/avatars/", %{"account_id" => b, "color" => 0xFF0000, "size" => 30})

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "color" => 0xFF0000,
             "size" => 30
           }
  end

  test "PATCH /api/avatars/:account_id", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    avatar_fixture(a)

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/avatars/#{a}", %{"color" => 0xFF0000, "size" => 30})

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "color" => 0xFF0000,
             "size" => 30
           }
  end

  test "PATCH /api/avatars/:account_id (missing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/avatars/#{a}", %{"color" => 0xFF0000, "size" => 30})

    assert json_response(conn, 404) === %{"errors" => %{"detail" => "Not Found"}}
  end
end
