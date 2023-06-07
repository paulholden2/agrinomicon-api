defmodule AgrinomiconWeb.FeatureControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.GisFixtures
  import Agrinomicon.GeometryFixtures

  alias Agrinomicon.Gis.Feature

  @create_attrs %{
    geometry: geometry_fixture(),
    properties: %{"some" => "map"}
  }
  @update_attrs %{
    geometry: geometry_fixture(),
    properties: %{"some" => "updated map"}
  }
  @invalid_attrs %{
    geometry: nil,
    properties: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all features", %{conn: conn} do
      conn = get(conn, ~p"/api/features")
      assert json_response(conn, 200)["data"] == []
    end

    test "lists features within bounding box", %{conn: conn} do
      nw = "-119.089804 35.259802"
      se = "-119.083496 35.256431"

      inside =
        feature_fixture(
          geometry:
            Geo.JSON.decode(
              Jason.decode!('{"coordinates":[-119.086681,35.258198],"type":"Point"}')
            )
        )

      _outside =
        feature_fixture(
          geometry:
            Geo.JSON.decode(
              Jason.decode!('{"coordinates":[-119.085197,35.260685],"type":"Point"}')
            )
        )

      conn = get(conn, ~p"/api/features?nw=#{nw}&se=#{se}")

      assert json_response(conn, 200)["data"]
             |> Enum.map(fn %{"geometry" => g} -> Geo.JSON.decode!(g) end) == [inside.geometry]
    end
  end

  describe "create feature" do
    test "renders feature when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/features", feature: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/features/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/features", feature: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show feature" do
    setup [:create_feature]

    test "renders feature when valid ID is passed", %{conn: conn, feature: feature} do
      conn = get(conn, ~p"/api/features/#{feature.id}")
      assert json_response(conn, 200)
    end

    test "renders 404 when invalid ID is passed", %{conn: conn} do
      conn = get(conn, ~p"/api/features/not_a_binary_id")
      assert json_response(conn, 404)
    end
  end

  describe "update feature" do
    setup [:create_feature]

    test "renders feature when data is valid", %{conn: conn, feature: %Feature{id: id} = feature} do
      conn = put(conn, ~p"/api/features/#{feature}", feature: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/features/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, feature: feature} do
      conn = put(conn, ~p"/api/features/#{feature}", feature: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete feature" do
    setup [:create_feature]

    test "deletes chosen feature", %{conn: conn, feature: feature} do
      conn = delete(conn, ~p"/api/features/#{feature}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/features/#{feature}")
      end
    end
  end

  defp create_feature(_) do
    feature = feature_fixture()
    %{feature: feature}
  end
end
