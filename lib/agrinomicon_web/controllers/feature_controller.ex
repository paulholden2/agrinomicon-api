defmodule AgrinomiconWeb.FeatureController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Gis
  alias Agrinomicon.Gis.Feature

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    features = Gis.list_features()
    render(conn, :index, features: features)
  end

  def create(conn, %{"feature" => feature_params}) do
    with {:ok, %Feature{} = feature} <- Gis.create_feature(feature_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/features/#{feature}")
      |> render(:show, feature: feature)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, binary_id} <- Ecto.UUID.cast(id) do
      feature = Gis.get_feature!(binary_id)
      render(conn, :show, feature: feature)
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    feature = Gis.get_feature!(id)

    with {:ok, %Feature{} = feature} <- Gis.update_feature(feature, feature_params) do
      render(conn, :show, feature: feature)
    end
  end

  def delete(conn, %{"id" => id}) do
    feature = Gis.get_feature!(id)

    with {:ok, %Feature{}} <- Gis.delete_feature(feature) do
      send_resp(conn, :no_content, "")
    end
  end
end
