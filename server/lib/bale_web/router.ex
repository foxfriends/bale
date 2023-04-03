defmodule BaleWeb.Router do
  use BaleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :identity do
    plug BaleWeb.Identity
    plug BaleWeb.AtMe
  end

  scope "/api/auth", BaleWeb do
    pipe_through :api

    post "/new", AuthController, :sign_up
    post "/", AuthController, :identify
  end

  scope "/api", BaleWeb do
    pipe_through [:api, :identity]

    scope "/relationships/:account_id" do
      get "/:partner_id", RelationshipController, :get
      put "/:partner_id", RelationshipController, :update
      patch "/:partner_id", RelationshipController, :partial_update
    end

    scope "/profiles" do
      get "/:account_id/", ProfileController, :get
      post "/", ProfileController, :create
      patch "/:account_id", ProfileController, :partial_update
    end

    scope "/avatars" do
      get "/:account_id/", AvatarController, :get
      post "/", AvatarController, :create
      patch "/:account_id", AvatarController, :partial_update
    end

    scope "/events" do
      post "/", EventController, :create

      scope "/:event_id" do
        get "/", EventController, :get
        patch "/", EventController, :partial_update
        delete "/", EventController, :delete

        scope "/attendees/:account_id" do
          patch "/", EventController, :update_attendee
        end
      end
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:bale, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BaleWeb.Telemetry
    end
  end
end
