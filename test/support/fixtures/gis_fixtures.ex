defmodule Agrinomicon.GisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agrinomicon.Gis` context.
  """

  import Agrinomicon.GeometryFixtures

  @doc """
  Generate a feature.
  """
  def feature_fixture(attrs \\ %{}) do
    {:ok, feature} =
      attrs
      |> Enum.into(%{
        geometry: geometry_fixture(),
        properties: %{"some" => "map"}
      })
      |> Agrinomicon.Gis.create_feature()

    feature
  end
end
