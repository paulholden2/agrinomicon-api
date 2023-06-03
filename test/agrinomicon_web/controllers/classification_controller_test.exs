defmodule AgrinomiconWeb.ClassificationControllerTest do
  use AgrinomiconWeb.ConnCase

  import Agrinomicon.TaxonomyFixtures

  alias Agrinomicon.Taxonomy.Classification

  @create_attrs %{
    binomial_name: "some binomial_name",
    genus: "some genus",
    kingdom: :animalia,
    species: "some species"
  }
  @update_attrs %{
    binomial_name: "some updated binomial_name",
    genus: "some updated genus",
    kingdom: :plantae,
    species: "some updated species"
  }
  @invalid_attrs %{binomial_name: nil, genus: nil, kingdom: nil, species: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all classifications", %{conn: conn} do
      conn = get(conn, ~p"/api/classifications")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create classification" do
    test "renders classification when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/classifications", classification: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/classifications/#{id}")

      assert %{
               "id" => ^id,
               "binomial_name" => "some binomial_name",
               "genus" => "some genus",
               "kingdom" => "animalia",
               "species" => "some species",
               "aliases" => nil,
               "common_names" => nil
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/classifications", classification: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show classification" do
    setup [:create_classification]

    test "renders classification when valid ID is passed", %{
      conn: conn,
      classification: classification
    } do
      conn = get(conn, ~p"/api/classifications/#{classification.id}")
      assert json_response(conn, 200)
    end

    test "renders 404 when invalid ID is passed", %{conn: conn} do
      conn = get(conn, ~p"/api/classifications/not_a_binary_id")
      assert json_response(conn, 404)
    end
  end

  describe "update classification" do
    setup [:create_classification]

    test "renders classification when data is valid", %{
      conn: conn,
      classification: %Classification{id: id} = classification
    } do
      conn = put(conn, ~p"/api/classifications/#{classification}", classification: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/classifications/#{id}")

      assert %{
               "id" => ^id,
               "binomial_name" => "some updated binomial_name",
               "genus" => "some updated genus",
               "kingdom" => "plantae",
               "species" => "some updated species",
               "aliases" => nil,
               "common_names" => nil
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, classification: classification} do
      conn = put(conn, ~p"/api/classifications/#{classification}", classification: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete classification" do
    setup [:create_classification]

    test "deletes chosen classification", %{conn: conn, classification: classification} do
      conn = delete(conn, ~p"/api/classifications/#{classification}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/classifications/#{classification}")
      end
    end
  end

  defp create_classification(_) do
    classification = classification_fixture()
    %{classification: classification}
  end
end
