defmodule AgrinomiconWeb.FeatureJSON do
  alias Agrinomicon.Gis.Feature

  @doc """
  Renders a list of features.
  """
  def index(%{features: features}) do
    %{data: for(feature <- features, do: data(feature))}
  end

  @doc """
  Renders a single feature.
  """
  def show(%{feature: feature}) do
    %{data: data(feature)}
  end

  defp data(%Feature{} = feature) do
    %{
      id: feature.id,
      type: "features",
      geometry: feature.geometry,
      properties: feature.properties || %{}
    }
  end
end
