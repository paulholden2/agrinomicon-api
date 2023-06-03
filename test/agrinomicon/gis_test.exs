defmodule Agrinomicon.GisTest do
  use Agrinomicon.DataCase

  alias Agrinomicon.Gis

  describe "features" do
    alias Agrinomicon.Gis.Feature

    import Agrinomicon.GisFixtures
    import Agrinomicon.GeometryFixtures

    @invalid_attrs %{geometry: nil, properties: nil}

    test "list_features/0 returns all features" do
      feature = feature_fixture()
      assert Gis.list_features() == [feature]
    end

    test "get_feature!/1 returns the feature with given id" do
      feature = feature_fixture()
      assert Gis.get_feature!(feature.id) == feature
    end

    test "create_feature/1 with valid data creates a feature" do
      valid_attrs = %{
        geometry: geometry_fixture(),
        properties: %{"some" => "map"}
      }

      assert {:ok, %Feature{} = _feature} = Gis.create_feature(valid_attrs)
    end

    test "create_feature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gis.create_feature(@invalid_attrs)
    end

    test "update_feature/2 with valid data updates the feature" do
      feature = feature_fixture()

      update_attrs = %{
        geometry: geometry_fixture()
      }

      assert {:ok, %Feature{} = _feature} = Gis.update_feature(feature, update_attrs)
    end

    test "update_feature/2 with invalid data returns error changeset" do
      feature = feature_fixture()
      assert {:error, %Ecto.Changeset{}} = Gis.update_feature(feature, @invalid_attrs)
      assert feature == Gis.get_feature!(feature.id)
    end

    test "delete_feature/1 deletes the feature" do
      feature = feature_fixture()
      assert {:ok, %Feature{}} = Gis.delete_feature(feature)
      assert_raise Ecto.NoResultsError, fn -> Gis.get_feature!(feature.id) end
    end

    test "change_feature/1 returns a feature changeset" do
      feature = feature_fixture()
      assert %Ecto.Changeset{} = Gis.change_feature(feature)
    end
  end
end
