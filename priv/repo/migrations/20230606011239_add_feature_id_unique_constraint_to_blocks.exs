defmodule Agrinomicon.Repo.Migrations.AddFeatureIdUniqueConstraintToBlocks do
  use Ecto.Migration

  def change do
    drop index(:blocks, [:feature_id])
    create unique_index(:blocks, [:feature_id])
  end
end
