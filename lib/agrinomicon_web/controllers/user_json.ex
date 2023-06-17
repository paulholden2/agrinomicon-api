defmodule AgrinomiconWeb.UserJSON do
  alias Agrinomicon.Iam.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      type: "users",
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    }
  end
end
