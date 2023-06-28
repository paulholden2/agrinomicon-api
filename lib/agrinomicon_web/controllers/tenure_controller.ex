defmodule AgrinomiconWeb.TenureController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Production
  alias Agrinomicon.Production.Tenure

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    tenures = Production.list_tenures()
    render(conn, :index, tenures: tenures)
  end

  def create(conn, %{"tenure" => tenure_params}) do
    with {:ok, %Tenure{} = tenure} <- Production.create_tenure(tenure_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tenures/#{tenure}")
      |> render(:show, tenure: tenure)
    end
  end

  def show(conn, %{"id" => id}) do
    tenure = Production.get_tenure!(id)
    render(conn, :show, tenure: tenure)
  end

  def update(conn, %{"id" => id, "tenure" => tenure_params}) do
    tenure = Production.get_tenure!(id, preloads: :distributions)

    with {:ok, %Tenure{} = tenure} <- Production.update_tenure(tenure, tenure_params) do
      render(conn, :show, tenure: tenure)
    end
  end

  def delete(conn, %{"id" => id}) do
    tenure = Production.get_tenure!(id)

    with {:ok, %Tenure{}} <- Production.delete_tenure(tenure) do
      send_resp(conn, :no_content, "")
    end
  end
end
