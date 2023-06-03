defmodule AgrinomiconWeb.FeatureGEOJSONTest do
  use AgrinomiconWeb.ConnCase, async: true

  import Agrinomicon.GisFixtures

  test "renders single feature" do
    feature = feature_fixture()

    assert AgrinomiconWeb.FeatureGEOJSON.show(%{feature: feature})
           |> Jason.encode!()
           |> Jason.decode!()
           |> Geo.JSON.decode!()
  end

  test "renders list of feature" do
    feature = feature_fixture()

    assert AgrinomiconWeb.FeatureGEOJSON.index(%{features: [feature, feature]})
           |> Jason.encode!()
           |> Jason.decode!()
           |> Geo.JSON.decode!()
  end
end
