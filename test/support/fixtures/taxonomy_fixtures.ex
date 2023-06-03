defmodule Agrinomicon.TaxonomyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agrinomicon.Taxonomy` context.
  """

  @doc """
  Generate a classification.
  """
  def classification_fixture(attrs \\ %{}) do
    {:ok, classification} =
      attrs
      |> Enum.into(%{
        binomial_name: "some binomial_name",
        genus: "some genus",
        kingdom: :animalia,
        species: "some species",
        aliases: ["some alias"],
        common_names: ["some common name"]
      })
      |> Agrinomicon.Taxonomy.create_classification()

    classification
  end

  @doc """
  Generate a variety.
  """
  def variety_fixture(attrs \\ %{}) do
    {:ok, variety} =
      attrs
      |> Enum.into(%{
        denomination: "some denomination",
        classification_id: classification_fixture().id
      })
      |> Agrinomicon.Taxonomy.create_variety()

    variety
  end
end
