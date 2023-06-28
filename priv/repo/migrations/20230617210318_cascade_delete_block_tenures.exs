defmodule Agrinomicon.Repo.Migrations.CascadeDeleteBlockTenures do
  use Ecto.Migration

  def change do
    drop constraint(:tenures, :tenures_block_id_fkey)

    alter table(:tenures) do
      modify :block_id, references(:blocks, type: :uuid, on_delete: :delete_all)
    end
  end
end
