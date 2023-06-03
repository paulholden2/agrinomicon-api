defmodule Agrinomicon.Repo.Migrations.AddPropertiesToFeatures do
  use Ecto.Migration

  def change do
    alter table(:features) do
      add :properties, :map, default: %{}
    end
  end
end
