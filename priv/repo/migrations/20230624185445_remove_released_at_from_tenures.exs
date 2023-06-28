defmodule Agrinomicon.Repo.Migrations.RemoveReleasedAtFromTenures do
  use Ecto.Migration

  def change do
    alter table(:tenures) do
      remove(:released_at)
    end
  end
end
