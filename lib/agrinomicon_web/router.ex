defmodule AgrinomiconWeb.Router do
  use AgrinomiconWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug AgrinomiconWeb.Authentication
  end

  pipeline :graphql do
    plug AgrinomiconWeb.Authentication
    plug AgrinomiconWeb.Context
  end

  scope "/api", AgrinomiconWeb do
    pipe_through :api

    resources "/classifications", ClassificationController
    resources "/varieties", VarietyController
    resources "/features", FeatureController
    resources "/organizations", OrganizationController
    resources "/blocks", BlockController
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:create, :delete]
  end

  scope "/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: AgrinomiconWeb.Graphql.Schema,
      adapter: Absinthe.Adapter.Underscore
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:agrinomicon, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
