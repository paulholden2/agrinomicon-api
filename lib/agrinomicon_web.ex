defmodule AgrinomiconWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use AgrinomiconWeb, :controller
      use AgrinomiconWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import AgrinomiconWeb.Authentication, only: [authenticate_user: 2, authenticate_request: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json, :geojson],
        layouts: [html: AgrinomiconWeb.Layouts]

      import Plug.Conn
      import AgrinomiconWeb.Gettext
      import AgrinomiconWeb.Authentication, only: [authenticate_user: 2, authenticate_request: 2]

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: AgrinomiconWeb.Endpoint,
        router: AgrinomiconWeb.Router,
        statics: AgrinomiconWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
