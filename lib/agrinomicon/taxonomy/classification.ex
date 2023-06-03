defmodule Agrinomicon.Taxonomy.Classification do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "classifications" do
    field :binomial_name, :string
    field :genus, :string
    field :kingdom, Ecto.Enum, values: [:animalia, :plantae]
    field :species, :string
    field :aliases, {:array, :string}
    field :common_names, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(classification, attrs) do
    classification
    |> cast(attrs, [:kingdom, :genus, :species, :binomial_name])
    |> unique_constraint([:genus, :species], error_key: :classification, message: "already exists")
    |> validate_required([:kingdom, :genus, :species, :binomial_name])
  end

  def scope(query, %Agrinomicon.Iam.User{}, _) do
    query
  end
end
