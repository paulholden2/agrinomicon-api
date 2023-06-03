defmodule AgrinomiconWeb.Resolvers.Organization do
  def list_organizations(_parent, _args, _resolution) do
    {:ok, Agrinomicon.Agency.list_organizations()}
  end
end
