defmodule AgrinomiconWeb.Resolvers.Block do
  def list_blocks(_parent, _args, _resolution) do
    {:ok, Agrinomicon.Agency.list_blocks()}
  end

  def get_block(_parent, %{id: id}, _resolution) do
    case Agrinomicon.Agency.get_block(id) do
      nil -> {:error, "Block #{id} not found"}
      user -> {:ok, user}
    end
  end
end
