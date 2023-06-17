defmodule AgrinomiconWeb.DistributionControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.ProductionFixtures

  alias Agrinomicon.Production.Distribution

  @create_attrs %{
    coverage: 42.5
  }
  @update_attrs %{
    coverage: 46.7
  }
  @invalid_attrs %{
    coverage: 100.5
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all distributions", %{conn: conn} do
      conn = get(conn, ~p"/api/distributions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create distribution" do
    test "renders distribution when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/distributions", distribution: @create_attrs |> Map.put(:tenure_id, tenure_fixture().id))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/distributions/#{id}")

      assert %{
               "id" => ^id,
               "coverage" => 42.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/distributions", distribution: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update distribution" do
    setup [:create_distribution]

    test "renders distribution when data is valid", %{conn: conn, distribution: %Distribution{id: id} = distribution} do
      conn = put(conn, ~p"/api/distributions/#{distribution}", distribution: @update_attrs |> Map.put(:tenure_id, tenure_fixture().id))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/distributions/#{id}")

      assert %{
               "id" => ^id,
               "coverage" => 46.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, distribution: distribution} do
      conn = put(conn, ~p"/api/distributions/#{distribution}", distribution: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete distribution" do
    setup [:create_distribution]

    test "deletes chosen distribution", %{conn: conn, distribution: distribution} do
      conn = delete(conn, ~p"/api/distributions/#{distribution}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/distributions/#{distribution}")
      end
    end
  end

  defp create_distribution(_) do
    distribution = distribution_fixture()
    %{distribution: distribution}
  end
end
