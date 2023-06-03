defmodule Agrinomicon.IamFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agrinomicon.Iam` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "john.doe#{System.unique_integer([:positive])}@example.com"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        first_name: "some first_name",
        last_name: "some last_name",
        password: "password"
      })
      |> Agrinomicon.Iam.create_user()

    user
  end

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, token, _claims} =
      Agrinomicon.Guardian.encode_and_sign(user_fixture(), %{}, token_type: :user)

    {:ok, session} =
      attrs
      |> Enum.into(%{
        token: token
      })
      |> Agrinomicon.Iam.create_session()

    session
  end
end
