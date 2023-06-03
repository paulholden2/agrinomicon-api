defmodule AgrinomiconWeb.Resolvers.Classification do
  alias Agrinomicon.Taxonomy

  def list_classifications(_parent, _args, _resolution) do
    {:ok, Taxonomy.list_classifications()}
  end
end
