defmodule Agrinomicon.IamTest do
  use Agrinomicon.DataCase

  alias Agrinomicon.Iam

  describe "users" do
    alias Agrinomicon.Iam.User

    import Agrinomicon.IamFixtures

    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Iam.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Iam.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        password: "some password"
      }

      assert {:ok, %User{} = user} = Iam.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Iam.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "some updated email",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        password: "some updated password"
      }

      assert {:ok, %User{} = user} = Iam.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert Bcrypt.verify_pass("some updated password", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Iam.update_user(user, @invalid_attrs)
      assert user == Iam.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Iam.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Iam.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Iam.change_user(user)
    end
  end

  describe "sessions" do
    alias Agrinomicon.Iam.Session

    import Agrinomicon.IamFixtures

    @invalid_attrs %{token: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Iam.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Iam.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{token: "some token"}

      assert {:ok, %Session{} = session} = Iam.create_session(valid_attrs)
      assert session.token == "some token"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Iam.create_session(@invalid_attrs)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Iam.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Iam.get_session!(session.id) end
    end
  end
end
