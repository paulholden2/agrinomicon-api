defmodule Agrinomicon.Repo.Migrations.AddCdlNameToClassifications do
  use Ecto.Migration

  def change do
    alter table(:classifications) do
      add :cdl_value, :string
    end

    create unique_index(:classifications, :cdl_value)
  end
end
