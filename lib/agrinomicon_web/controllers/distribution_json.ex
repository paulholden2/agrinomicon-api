defmodule AgrinomiconWeb.DistributionJSON do
  alias Agrinomicon.Production.Distribution

  @doc """
  Renders a list of distributions.
  """
  def index(%{distributions: distributions}) do
    %{data: for(distribution <- distributions, do: data(distribution))}
  end

  @doc """
  Renders a single distribution.
  """
  def show(%{distribution: distribution}) do
    %{data: data(distribution)}
  end

  defp data(%Distribution{} = distribution) do
    %{
      id: distribution.id,
      type: "distributions",
      coverage: distribution.coverage,
      tenure_id: distribution.tenure_id
    }
  end
end
