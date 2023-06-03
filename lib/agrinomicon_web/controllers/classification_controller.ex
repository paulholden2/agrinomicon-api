defmodule AgrinomiconWeb.ClassificationController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Taxonomy
  alias Agrinomicon.Taxonomy.Classification

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(Taxonomy.Policy, :list_classifications, conn.assigns[:current_user]) do
      classifications = Taxonomy.list_classifications()
      render(conn, :index, classifications: classifications)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def create(conn, %{"classification" => classification_params}) do
    with {:ok, %Classification{} = classification} <-
           Taxonomy.create_classification(classification_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/classifications/#{classification}")
      |> render(:show, classification: classification)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, binary_id} <- Ecto.UUID.cast(id) do
      classification = Taxonomy.get_classification!(binary_id)
      render(conn, :show, classification: classification)
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "classification" => classification_params}) do
    classification = Taxonomy.get_classification!(id)

    with {:ok, %Classification{} = classification} <-
           Taxonomy.update_classification(classification, classification_params) do
      render(conn, :show, classification: classification)
    end
  end

  def delete(conn, %{"id" => id}) do
    classification = Taxonomy.get_classification!(id)

    with {:ok, %Classification{}} <- Taxonomy.delete_classification(classification) do
      send_resp(conn, :no_content, "")
    end
  end
end
