defmodule AgrinomiconWeb.TenureControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.ProductionFixtures

  alias Agrinomicon.Production.Tenure

  @create_attrs %{
    occupied_at: ~U[2023-06-10 21:51:00Z],
    released_at: ~U[2023-06-10 21:51:00Z]
  }
  @update_attrs %{
    occupied_at: ~U[2023-06-11 21:51:00Z],
    released_at: ~U[2023-06-11 21:51:00Z]
  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tenures", %{conn: conn} do
      conn = get(conn, ~p"/api/tenures")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tenure" do
    test "renders tenure when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tenures", tenure: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tenures/#{id}")

      assert %{
               "id" => ^id,
               "occupied_at" => "2023-06-10T21:51:00Z",
               "released_at" => "2023-06-10T21:51:00Z"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tenures", tenure: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tenure" do
    setup [:create_tenure]

    test "renders tenure when data is valid", %{conn: conn, tenure: %Tenure{id: id} = tenure} do
      conn = put(conn, ~p"/api/tenures/#{tenure}", tenure: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tenures/#{id}")

      assert %{
               "id" => ^id,
               "occupied_at" => "2023-06-11T21:51:00Z",
               "released_at" => "2023-06-11T21:51:00Z"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, tenure: tenure} do
      conn = put(conn, ~p"/api/tenures/#{tenure}", tenure: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tenure" do
    setup [:create_tenure]

    test "deletes chosen tenure", %{conn: conn, tenure: tenure} do
      conn = delete(conn, ~p"/api/tenures/#{tenure}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tenures/#{tenure}")
      end
    end
  end

  defp create_tenure(_) do
    tenure = tenure_fixture()
    %{tenure: tenure}
  end
end
