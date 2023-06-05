defmodule AgrinomiconWeb.BlockControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.AgencyFixtures
  import Agrinomicon.GeometryFixtures

  alias Agrinomicon.Agency.Block

  @create_attrs %{
    name: "some name",
    feature: %{
      geometry: geometry_fixture()
    }
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all blocks", %{conn: conn} do
      conn = get(conn, ~p"/api/blocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create block" do
    test "renders block when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/blocks", block: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/blocks/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "feature_id" => _feature_id
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/blocks", block: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update block" do
    setup [:create_block]

    test "renders block when data is valid", %{conn: conn, block: %Block{id: id} = block} do
      conn = put(conn, ~p"/api/blocks/#{block}", block: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/blocks/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, block: block} do
      conn = put(conn, ~p"/api/blocks/#{block}", block: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete block" do
    setup [:create_block]

    test "deletes chosen block", %{conn: conn, block: block} do
      conn = delete(conn, ~p"/api/blocks/#{block}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/blocks/#{block}")
      end
    end
  end

  defp create_block(_) do
    block = block_fixture()
    %{block: block}
  end
end
