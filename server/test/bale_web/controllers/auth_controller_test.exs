defmodule BaleWeb.AuthControllerTest do
  use BaleWeb.ConnCase
  import BaleWeb.AuthFixtures

  test "POST /api/auth/new (ok)", %{conn: conn} do
    conn =
      post(conn, ~p"/api/auth/new", %{
        "username" => "test",
        "email" => "test@example.com",
        "password" => "password123"
      })

    assert json_response(conn, 200) === %{"ok" => true}
  end

  test "POST /api/auth/new (conflict in name)", %{conn: conn} do
    account_fixture("test", "notemail@example.com")

    conn =
      post(conn, ~p"/api/auth/new", %{
        "username" => "test",
        "email" => "test@example.com",
        "password" => "password123"
      })

    assert json_response(conn, 409) === %{"errors" => %{"detail" => "Conflict"}}
  end

  test "POST /api/auth/new (conflict in email)", %{conn: conn} do
    account_fixture("nottest", "test@example.com")

    conn =
      post(conn, ~p"/api/auth/new", %{
        "username" => "test",
        "email" => "test@example.com",
        "password" => "password123"
      })

    assert json_response(conn, 409) === %{"errors" => %{"detail" => "Conflict"}}
  end

  test "POST /api/auth/ (ok)", %{conn: conn} do
    {:ok, account_id} = account_fixture("test", "test@example.com", "test123")

    conn =
      post(conn, ~p"/api/auth", %{
        "username" => "test",
        "password" => "test123"
      })

    assert %{"identity_token" => token} = json_response(conn, 200)
    assert %{"sub" => ^account_id} = BaleWeb.IdentityToken.verify_and_validate!(token)
  end

  test "POST /api/auth/ (wrong password)", %{conn: conn} do
    account_fixture("test", "test@example.com", "test123")

    conn =
      post(conn, ~p"/api/auth", %{
        "username" => "test",
        "password" => "test124"
      })

    assert json_response(conn, 401) === %{"errors" => %{"detail" => "Unauthorized"}}
  end
end
