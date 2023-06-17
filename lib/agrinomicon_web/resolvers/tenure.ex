defmodule AgrinomiconWeb.Resolvers.Tenure do
  def list_tenures(_parent, _args, _resolution) do
    {:ok, Agrinomicon.Production.list_tenures()}
  end
end
