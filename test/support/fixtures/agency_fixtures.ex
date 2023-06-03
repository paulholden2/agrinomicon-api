defmodule Agrinomicon.AgencyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Agrinomicon.Agency` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Agrinomicon.Agency.create_organization()

    organization
  end

  @doc """
  Generate a block.
  """
  def block_fixture(attrs \\ %{}) do
    {:ok, block} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Agrinomicon.Agency.create_block()

    block
  end
end
