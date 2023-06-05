defmodule AgrinomiconWeb.CORS do
  use Corsica.Router,
    origins: ["http://localhost", ~r{^https?://(.*\.)?agrinomicon\.com$}],
    allow_credentials: true,
    max_age: 600

  resource("/api/*", origins: "*", allow_headers: ["Content-Type"])
  resource("/graphql", origins: "*", allow_headers: ["Content-Type"])
end
