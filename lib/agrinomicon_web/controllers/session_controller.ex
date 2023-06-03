defmodule AgrinomiconWeb.SessionController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Iam

  action_fallback AgrinomiconWeb.FallbackController

  def create(conn, %{"session" => session_params}) do
    with %Iam.User{} = user <- Iam.get_user_by_email(session_params["email"]),
         true <- Bcrypt.verify_pass(session_params["password"], user.password_hash),
         {:ok, jwt, _claims} <-
           Agrinomicon.Guardian.encode_and_sign(user, %{}, token_type: :user),
         {:ok, session} <- Iam.create_session(%{token: jwt, user_id: user.id}) do
      conn
      |> put_status(:created)
      |> render(:show, session: session)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def delete(conn, %{"id" => _}) do
    send_resp(conn, :no_content, "")
  end
end
