defmodule AgrinomiconWeb.VarietyControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.TaxonomyFixtures

  alias Agrinomicon.Taxonomy.Variety

  @create_attrs %{
    denomination: "some denomination"
  }
  @update_attrs %{
    denomination: "some updated denomination"
  }
  @invalid_attrs %{denomination: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all varieties", %{conn: conn} do
      conn = get(conn, ~p"/api/varieties")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create variety" do
    test "renders variety when data is valid", %{conn: conn} do
      conn =
        post(conn, ~p"/api/varieties",
          variety:
            @create_attrs
            |> Map.put(
              :classification_id,
              classification_fixture(genus: "create variety genus").id
            )
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/varieties/#{id}")

      assert %{
               "id" => ^id,
               "denomination" => "some denomination"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/varieties", variety: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update variety" do
    setup [:create_variety]

    test "renders variety when data is valid", %{conn: conn, variety: %Variety{id: id} = variety} do
      conn =
        put(conn, ~p"/api/varieties/#{variety}",
          variety:
            @update_attrs
            |> Map.put(
              :classification_id,
              classification_fixture(genus: "update variety genus").id
            )
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/varieties/#{id}")

      assert %{
               "id" => ^id,
               "denomination" => "some updated denomination"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, variety: variety} do
      conn = put(conn, ~p"/api/varieties/#{variety}", variety: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete variety" do
    setup [:create_variety]

    test "deletes chosen variety", %{conn: conn, variety: variety} do
      conn = delete(conn, ~p"/api/varieties/#{variety}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/varieties/#{variety}")
      end
    end
  end

  defp create_variety(_) do
    variety = variety_fixture()
    %{variety: variety}
  end
end
