defmodule BaleWeb.EventControllerTest do
  alias Bale.Schema.Event
  use BaleWeb.ConnCase
  import BaleWeb.AuthFixtures
  import BaleWeb.EventFixtures

  test "GET /api/events/:event_id", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, %Event{id: e}} = event_fixture(a)

    conn =
      conn
      |> auth_as(a)
      |> get(~p"/api/events/#{e}")

    assert json_response(conn, 200) === %{
             "id" => e,
             "title" => "Test Event",
             "description" => "It's going to be tested.",
             "location" => "Home",
             "is_public" => true,
             "is_joinable" => true,
             "is_subgroupable" => false,
             "host_id" => a,
             "image_id" => nil,
             "occurs_at" => nil,
             "attendees" => []
           }
  end

  test "POST /api/events/", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/events/", %{"title" => "Cool Games Night"})

    assert %{
             "id" => e,
             "title" => "Cool Games Night",
             "description" => "",
             "location" => "",
             "is_public" => false,
             "is_joinable" => false,
             "is_subgroupable" => false,
             "host_id" => ^a,
             "image_id" => nil,
             "occurs_at" => nil,
             "attendees" => [
               %{"account_id" => ^a, "event_id" => e, "state" => "hosting"}
             ]
           } = json_response(conn, 200)
  end

  test "POST /api/events/ (someone else)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/events/", %{"host_id" => b})

    assert %{
             "id" => e,
             "title" => "",
             "description" => "",
             "location" => "",
             "is_public" => false,
             "is_joinable" => false,
             "is_subgroupable" => false,
             "host_id" => ^a,
             "image_id" => nil,
             "occurs_at" => nil,
             "attendees" => [
               %{"account_id" => ^a, "event_id" => e, "state" => "hosting"}
             ]
           } = json_response(conn, 200)
  end

  test "PATCH /api/events/:event_id", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, %Event{id: e}} = event_fixture(a)

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/events/#{e}", %{"title" => "Cooler Games Night"})

    assert json_response(conn, 200) === %{
             "id" => e,
             "title" => "Cooler Games Night",
             "description" => "It's going to be tested.",
             "location" => "Home",
             "is_public" => true,
             "is_joinable" => true,
             "is_subgroupable" => false,
             "host_id" => a,
             "image_id" => nil,
             "occurs_at" => nil,
             "attendees" => []
           }
  end

  test "PATCH /api/events/:event_id (missing)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> patch(~p"/api/events/#{a}", %{})

    assert json_response(conn, 404) === %{"errors" => %{"detail" => "Not Found"}}
  end

  test "POST /api/events/:event_id/rsvp", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")
    {:ok, b} = account_fixture("b", "b@example.com")
    {:ok, %Event{id: e}} = event_fixture(a)

    conn =
      conn
      |> auth_as(b)
      |> post(~p"/api/events/#{e}/rsvp", %{"state" => "attending"})

    assert json_response(conn, 200) === %{
             "event_id" => e,
             "account_id" => b,
             "state" => "attending"
           }
  end

  test "POST /api/events/:event_id/rsvp (not found)", %{conn: conn} do
    {:ok, a} = account_fixture("a", "a@example.com")

    conn =
      conn
      |> auth_as(a)
      |> post(~p"/api/events/#{a}/rsvp", %{"state" => "attending"})

    assert json_response(conn, 404) === %{"errors" => %{"detail" => "Not Found"}}
  end
end
