defmodule Agrinomicon.Repo.Migrations.CascadeDeleteTenureDistributions do
  use Ecto.Migration

  def change do
    drop constraint(:distributions, :distributions_tenure_id_fkey)

    alter table(:distributions) do
      modify :tenure_id, references(:tenures, type: :uuid, on_delete: :delete_all)
    end
  end
end
