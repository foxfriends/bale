defmodule BaleWeb.RelationshipControllerTest do
  use BaleWeb.ConnCase
  import BaleWeb.AuthFixtures
  import BaleWeb.RelationshipFixtures

  test "PUT /api/relationship/:account/:partner (new)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> put(~p"/api/relationships/#{a}/#{b}", %{
        "level" => "friend",
        "is_following" => true
      })

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "partner_id" => b,
             "level" => "friend",
             "is_following" => true
           }
  end

  test "PUT /api/relationship/:account/:partner (existing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    relationship_fixture(a, b, :friend, true)

    conn =
      conn
      |> auth_as(a)
      |> put(~p"/api/relationships/#{a}/#{b}", %{
        "level" => "neutral",
        "is_following" => false
      })

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "partner_id" => b,
             "level" => "neutral",
             "is_following" => false
           }
  end

  test "PUT /api/relationship/:account/:partner (partial)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    relationship_fixture(a, b, :friend, true)

    conn =
      conn
      |> auth_as(a)
      |> put(~p"/api/relationships/#{a}/#{b}", %{
        "is_following" => false
      })

    assert json_response(conn, 400) === %{"errors" => %{"detail" => "Bad Request"}}
  end

  test "PUT /api/relationship/:account/:partner (not yours)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> put(~p"/api/relationships/#{b}/#{a}", %{
        "level" => "neutral",
        "is_following" => false
      })

    assert json_response(conn, 403) === %{"errors" => %{"detail" => "Forbidden"}}
  end

  test "PATCH /api/relationship/:account/:partner (new)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/relationships/#{a}/#{b}", %{"is_following" => false})

    assert json_response(conn, 404) === %{"errors" => %{"detail" => "Not Found"}}
  end

  test "PATCH /api/relationship/:account/:partner (existing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    relationship_fixture(a, b, :friend)

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/relationships/#{a}/#{b}", %{"is_following" => false})

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "partner_id" => b,
             "level" => "friend",
             "is_following" => false
           }
  end

  test "PATCH /api/relationship/:account/:partner (not yours)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/relationships/#{b}/#{a}", %{"is_following" => false})

    assert json_response(conn, 403) === %{"errors" => %{"detail" => "Forbidden"}}
  end

  test "GET /api/relationship/:account/:partner (existing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    relationship_fixture(a, b, :friend, true)

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/relationships/#{a}/#{b}")

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "partner_id" => b,
             "level" => "friend",
             "is_following" => true
           }
  end

  test "GET /api/relationship/:account/:partner (not existing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/relationships/#{a}/#{b}")

    assert json_response(conn, 404) === %{"errors" => %{"detail" => "Not Found"}}
  end

  test "GET /api/relationship/:account/:partner (not yours)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    relationship_fixture(a, b, :friend, true)

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/relationships/#{b}/#{a}")

    assert json_response(conn, 403) === %{"errors" => %{"detail" => "Forbidden"}}
  end

  test "GET /api/relationship/@me/:partner", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    relationship_fixture(a, b, :friend, true)
    relationship_fixture(b, a, :neutral, false)

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/relationships/@me/#{b}")

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "partner_id" => b,
             "level" => "friend",
             "is_following" => true
           }
  end
end
