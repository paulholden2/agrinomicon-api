defmodule AgrinomiconWeb.Resolvers.Feature do
  def list_features(_parent, _args, _resolution) do
    {:ok, Agrinomicon.Gis.list_features()}
  end
end
