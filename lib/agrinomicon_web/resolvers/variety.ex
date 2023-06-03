defmodule AgrinomiconWeb.Resolvers.Variety do
  def list_varieties(_parent, _args, _resolution) do
    {:ok, Agrinomicon.Taxonomy.list_varieties()}
  end
end
