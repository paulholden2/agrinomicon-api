defmodule Agrinomicon.ProductionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agrinomicon.Production` context.
  """

  @doc """
  Generate a tenure.
  """
  def tenure_fixture(attrs \\ %{}) do
    {:ok, tenure} =
      attrs
      |> Enum.into(%{
        occupied_at: ~U[2023-06-10 21:51:00Z],
        released_at: ~U[2023-06-10 21:51:00Z]
      })
      |> Agrinomicon.Production.create_tenure()

    tenure
  end

  @doc """
  Generate a distribution.
  """
  def distribution_fixture(attrs \\ %{}) do
    tenure = tenure_fixture()
    {:ok, distribution} =
      attrs
      |> Enum.into(%{
        coverage: 60.5,
        tenure_id: tenure.id
      })
      |> Agrinomicon.Production.create_distribution()

    distribution
  end
end
