defmodule AgrinomiconWeb.Resolvers.Block do
  def list_blocks(_parent, _args, _resolution) do
    {:ok, Agrinomicon.Agency.list_blocks()}
  end
end
