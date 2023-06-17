defmodule AgrinomiconWeb.TenureJSON do
  alias Agrinomicon.Production.Tenure

  @doc """
  Renders a list of tenures.
  """
  def index(%{tenures: tenures}) do
    %{data: for(tenure <- tenures, do: data(tenure))}
  end

  @doc """
  Renders a single tenure.
  """
  def show(%{tenure: tenure}) do
    %{data: data(tenure)}
  end

  defp data(%Tenure{} = tenure) do
    %{
      id: tenure.id,
      type: "tenures",
      occupied_at: tenure.occupied_at,
      released_at: tenure.released_at
    }
  end
end
