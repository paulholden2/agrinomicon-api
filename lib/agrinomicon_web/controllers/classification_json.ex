defmodule AgrinomiconWeb.ClassificationJSON do
  alias Agrinomicon.Taxonomy.Classification

  @doc """
  Renders a list of classifications.
  """
  def index(%{classifications: classifications}) do
    %{data: for(classification <- classifications, do: data(classification))}
  end

  @doc """
  Renders a single classification.
  """
  def show(%{classification: classification}) do
    %{data: data(classification)}
  end

  defp data(%Classification{} = classification) do
    %{
      id: classification.id,
      type: "classifications",
      kingdom: classification.kingdom,
      genus: classification.genus,
      species: classification.species,
      binomial_name: classification.binomial_name,
      aliases: classification.aliases,
      common_names: classification.common_names,
      cdl_value: classification.cdl_value,
      geometry_color: classification.geometry_color
    }
  end
end
