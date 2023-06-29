defmodule AgrinomiconWeb.BlockController do
  use AgrinomiconWeb, :controller

  alias Agrinomicon.Agency
  alias Agrinomicon.Agency.Block

  action_fallback AgrinomiconWeb.FallbackController

  def index(conn, _params) do
    blocks = Agency.list_blocks()
    render(conn, :index, blocks: blocks)
  end

  def create(conn, %{"block" => block_params}) do
    with {:ok, %Block{} = block} <- Agency.create_block(block_params) do
      Usda.Cdl.new(%{"block_id" => block.id})
      |> Oban.insert()

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/blocks/#{block}")
      |> render(:show, block: block)
    end
  end

  def show(conn, %{"id" => id}) do
    block = Agency.get_block!(id)
    render(conn, :show, block: block)
  end

  def update(conn, %{"id" => id, "block" => block_params}) do
    block = Agency.get_block!(id, preloads: [:feature, tenures: :distributions])

    with {:ok, %Block{} = block} <- Agency.update_block(block, block_params) do
      if "geometry" in block_params do
        Usda.Cdl.new(%{"block_id" => block.id})
        |> Oban.insert()
      end

      render(conn, :show, block: block)
    end
  end

  def delete(conn, %{"id" => id}) do
    block = Agency.get_block!(id)

    with {:ok, %Block{}} <- Agency.delete_block(block) do
      send_resp(conn, :no_content, "")
    end
  end
end
