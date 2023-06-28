defmodule Agrinomicon.Repo.Migrations.AddGeometryColorToClassifications do
  use Ecto.Migration

  def change do
    alter table(:classifications) do
      add :geometry_color, :string
    end
  end
end
