defmodule AgrinomiconWeb.UserController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Iam
  alias Agrinomicon.Iam.User

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    users = Iam.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Iam.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Iam.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Iam.get_user!(id)

    with {:ok, %User{} = user} <- Iam.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Iam.get_user!(id)

    with {:ok, %User{}} <- Iam.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
