defmodule AgrinomiconWeb.VarietyJSON do
  alias Agrinomicon.Taxonomy.Variety

  @doc """
  Renders a list of varieties.
  """
  def index(%{varieties: varieties}) do
    %{data: for(variety <- varieties, do: data(variety))}
  end

  @doc """
  Renders a single variety.
  """
  def show(%{variety: variety}) do
    %{data: data(variety)}
  end

  defp data(%Variety{} = variety) do
    {_, classification} =
      case variety.classification do
        %Ecto.Association.NotLoaded{} ->
          {:error, nil}

        nil ->
          {:error, nil}

        Agrinomicon.Taxonomy.Classification ->
          AgrinomiconWeb.ClassificationJSON.show(%{classification: variety.classification})
          |> Map.fetch(:data)
      end

    %{
      id: variety.id,
      denomination: variety.denomination,
      classification: classification
    }
  end
end
