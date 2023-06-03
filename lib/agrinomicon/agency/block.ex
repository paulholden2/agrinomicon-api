defmodule Agrinomicon.Agency.Block do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "blocks" do
    field :name, :string
    belongs_to :organization, Agrinomicon.Agency.Organization
    belongs_to :feature, Agrinomicon.Gis.Feature

    timestamps()
  end

  @doc false
  def changeset(block, attrs) do
    block
    |> cast(attrs, [:name])
  end
end
