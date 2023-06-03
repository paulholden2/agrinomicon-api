defmodule AgrinomiconWeb.Authentication do
  @moduledoc """
  A plug for authenticating users via the `Authorization` header.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts), do: conn

  @doc """
  A function plug that decodes and verifies a JWT and creates a connection assign
  for the claims.

  ## Examples

      # in a controller
      plug :authenticate_request, [token_type: :user] when action in [:index, :create]

  """
  def authenticate_request(conn, token_type: token_type) do
    conn
    |> get_token()
    |> verify_token(token_type)
    |> case do
      {:ok, claims} ->
        conn
        |> assign(:claims, claims)

      _unauthorized ->
        conn
        |> assign(:claims, nil)
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, Jason.encode!(%{errors: %{detail: "Unauthorized"}}))
        |> halt()
    end
  end

  @doc """
  Retrieve the assigned claims from the connection.
  """
  def claims(conn), do: conn.assigns[:claims]

  @doc """
  A function plug that decodes a `user` token and creates a `current_user` assign
  on the connection.

  ## Examples

      # in a controller
      plug :authenticate_user when action in [:index, :create]

  """
  def authenticate_user(conn, _opts) do
    conn = authenticate_request(conn, token_type: :user)

    user =
      conn
      |> claims
      |> Map.get("sub")
      |> Agrinomicon.Iam.get_user!()

    assign(conn, :current_user, user)
  end

  @spec verify_token(binary | nil, binary) :: {:ok, any} | :unauthorized
  def verify_token(token, token_type) do
    with {:ok, claims} <-
           Agrinomicon.Guardian.decode_and_verify(token, %{"typ" => to_string(token_type)}) do
      {:ok, claims}
    else
      _ -> :unauthorized
    end
  end

  @spec get_token(Plug.Conn.t()) :: nil | binary
  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end
end
