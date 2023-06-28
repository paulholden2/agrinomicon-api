defmodule AgrinomiconWeb.DistributionController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Production
  alias Agrinomicon.Production.Distribution

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, params) do
    distributions = Production.list_distributions(params)
    render(conn, :index, distributions: distributions)
  end

  def create(conn, %{"distribution" => distribution_params}) do
    with {:ok, %Distribution{} = distribution} <-
           Production.create_distribution(distribution_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/distributions/#{distribution}")
      |> render(:show, distribution: distribution)
    end
  end

  def show(conn, %{"id" => id}) do
    distribution = Production.get_distribution!(id)
    render(conn, :show, distribution: distribution)
  end

  def update(conn, %{"id" => id, "distribution" => distribution_params}) do
    distribution = Production.get_distribution!(id)

    with {:ok, %Distribution{} = distribution} <-
           Production.update_distribution(distribution, distribution_params) do
      render(conn, :show, distribution: distribution)
    end
  end

  def delete(conn, %{"id" => id}) do
    distribution = Production.get_distribution!(id)

    with {:ok, %Distribution{}} <- Production.delete_distribution(distribution) do
      send_resp(conn, :no_content, "")
    end
  end
end
