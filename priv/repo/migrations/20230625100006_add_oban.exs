defmodule Agrinomicon.Repo.Migrations.AddOban do
  use Ecto.Migration

  def up do
    Oban.Migration.up(version: 11)
  end

  def down do
    Oban.Migration.down(version: 1)
  end
end
