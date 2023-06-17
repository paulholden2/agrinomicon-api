defmodule AgrinomiconWeb.FeatureGEOJSON do
  alias Agrinomicon.Gis.Feature

  @doc """
  Renders a list of features.
  """
  def index(%{features: features}) do
    %{type: "FeatureCollection", features: for(feature <- features, do: data(feature))}
  end

  @doc """
  Renders a single feature.
  """
  def show(%{feature: feature}) do
    data(feature)
  end

  defp data(%Feature{} = feature) do
    %{
      id: feature.id,
      type: "Feature",
      geometry: feature.geometry,
      properties: feature.properties
    }
  end
end
