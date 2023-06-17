defmodule AgrinomiconWeb.BlockJSON do
  alias Agrinomicon.Agency.Block

  @doc """
  Renders a list of blocks.
  """
  def index(%{blocks: blocks}) do
    %{data: for(block <- blocks, do: data(block))}
  end

  @doc """
  Renders a single block.
  """
  def show(%{block: block}) do
    %{data: data(block)}
  end

  defp data(%Block{} = block) do
    %{
      id: block.id,
      type: "blocks",
      name: block.name,
      feature_id: block.feature_id
    }
  end
end
