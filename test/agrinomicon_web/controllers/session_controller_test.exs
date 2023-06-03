defmodule AgrinomiconWeb.SessionControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.IamFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create session" do
    setup [:create_user]

    test "renders session when data is valid", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/sessions", session: %{email: user.email, password: "password"})
      assert json_response(conn, 201)["data"]
    end

    test "renders errors when email is invalid", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/api/sessions", session: %{email: user.email <> ".au", password: "password"})

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders errors when password is invalid", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/api/sessions", session: %{email: user.email, password: "password, mate"})

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete(conn, ~p"/api/sessions/#{session}")
      assert response(conn, 204)
    end
  end

  defp create_session(_) do
    session = session_fixture()
    %{session: session}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
