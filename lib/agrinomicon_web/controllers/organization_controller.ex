defmodule AgrinomiconWeb.OrganizationController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Agency
  alias Agrinomicon.Agency.Organization

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    organizations = Agency.list_organizations()
    render(conn, :index, organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, %Organization{} = organization} <- Agency.create_organization(organization_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/organizations/#{organization}")
      |> render(:show, organization: organization)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, binary_id} <- Ecto.UUID.cast(id) do
      organization = Agency.get_organization!(binary_id)
      render(conn, :show, organization: organization)
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Agency.get_organization!(id)

    with {:ok, %Organization{} = organization} <-
           Agency.update_organization(organization, organization_params) do
      render(conn, :show, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Agency.get_organization!(id)

    with {:ok, %Organization{}} <- Agency.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end
