defmodule AgrinomiconWeb.VarietyController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Taxonomy
  alias Agrinomicon.Taxonomy.Variety

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    varieties = Taxonomy.list_varieties(preloads: [:classification])
    render(conn, :index, varieties: varieties)
  end

  def create(conn, %{"variety" => variety_params}) do
    with {:ok, %Variety{} = variety} <- Taxonomy.create_variety(variety_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/varieties/#{variety}")
      |> render(:show, variety: variety)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, binary_id} <- Ecto.UUID.cast(id) do
      variety = Taxonomy.get_variety!(binary_id, preloads: [:classification])
      render(conn, :show, variety: variety)
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "variety" => variety_params}) do
    variety = Taxonomy.get_variety!(id)

    with {:ok, %Variety{} = variety} <- Taxonomy.update_variety(variety, variety_params) do
      render(conn, :show, variety: variety)
    end
  end

  def delete(conn, %{"id" => id}) do
    variety = Taxonomy.get_variety!(id)

    with {:ok, %Variety{}} <- Taxonomy.delete_variety(variety) do
      send_resp(conn, :no_content, "")
    end
  end
end
