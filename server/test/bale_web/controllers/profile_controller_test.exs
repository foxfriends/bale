defmodule BaleWeb.ProfileControllerTest do
  use BaleWeb.ConnCase
  import BaleWeb.AuthFixtures
  import BaleWeb.ProfileFixtures

  test "GET /api/profiles/:account", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, _} = profile_fixture(a, "Testy McTestFace", "Testing", "", nil)

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/profiles/#{a}")

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "name" => "Testy McTestFace",
             "status" => "Testing",
             "bio" => "",
             "image_id" => nil
           }
  end

  test "POST /api/profiles/", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/profiles/", %{"name" => "Test Name", "bio" => "I like tests"})

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "name" => "Test Name",
             "status" => "",
             "bio" => "I like tests",
             "image_id" => nil
           }
  end

  test "POST /api/profiles/ (someone else)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/profiles/", %{
        "account_id" => b,
        "name" => "Test Name",
        "bio" => "I like tests"
      })

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "name" => "Test Name",
             "status" => "",
             "bio" => "I like tests",
             "image_id" => nil
           }
  end

  test "PATCH /api/profiles/", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, _} = profile_fixture(a, "Testy McTestFace", "Testing", "", nil)

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/profiles/#{a}", %{"status" => "Not Testing"})

    assert json_response(conn, 200) === %{
             "account_id" => a,
             "name" => "Testy McTestFace",
             "status" => "Not Testing",
             "bio" => "",
             "image_id" => nil
           }
  end

  test "PATCH /api/profiles/ (missing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/profiles/#{a}", %{"status" => "Not Testing"})

    assert json_response(conn, 404) === %{"errors" => %{"detail" => "Not Found"}}
  end
end
