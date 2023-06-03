defmodule Agrinomicon.TaxonomyTest do
  use Agrinomicon.DataCase

  alias Agrinomicon.Taxonomy

  describe "classifications" do
    alias Agrinomicon.Taxonomy.Classification

    import Agrinomicon.TaxonomyFixtures

    @invalid_attrs %{binomial_name: nil, genus: nil, kingdom: nil, species: nil}

    test "list_classifications/0 returns all classifications" do
      classification = classification_fixture()
      assert Taxonomy.list_classifications() == [classification]
    end

    test "get_classification!/1 returns the classification with given id" do
      classification = classification_fixture()
      assert Taxonomy.get_classification!(classification.id) == classification
    end

    test "create_classification/1 with valid data creates a classification" do
      valid_attrs = %{
        binomial_name: "some binomial_name",
        genus: "some genus",
        kingdom: :animalia,
        species: "some species"
      }

      assert {:ok, %Classification{} = classification} =
               Taxonomy.create_classification(valid_attrs)

      assert classification.binomial_name == "some binomial_name"
      assert classification.genus == "some genus"
      assert classification.kingdom == :animalia
      assert classification.species == "some species"
    end

    test "create_classification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Taxonomy.create_classification(@invalid_attrs)
    end

    test "update_classification/2 with valid data updates the classification" do
      classification = classification_fixture()

      update_attrs = %{
        binomial_name: "some updated binomial_name",
        genus: "some updated genus",
        kingdom: :plantae,
        species: "some updated species"
      }

      assert {:ok, %Classification{} = classification} =
               Taxonomy.update_classification(classification, update_attrs)

      assert classification.binomial_name == "some updated binomial_name"
      assert classification.genus == "some updated genus"
      assert classification.kingdom == :plantae
      assert classification.species == "some updated species"
    end

    test "update_classification/2 with invalid data returns error changeset" do
      classification = classification_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Taxonomy.update_classification(classification, @invalid_attrs)

      assert classification == Taxonomy.get_classification!(classification.id)
    end

    test "delete_classification/1 deletes the classification" do
      classification = classification_fixture()
      assert {:ok, %Classification{}} = Taxonomy.delete_classification(classification)
      assert_raise Ecto.NoResultsError, fn -> Taxonomy.get_classification!(classification.id) end
    end

    test "change_classification/1 returns a classification changeset" do
      classification = classification_fixture()
      assert %Ecto.Changeset{} = Taxonomy.change_classification(classification)
    end
  end

  describe "varieties" do
    alias Agrinomicon.Taxonomy.Variety

    import Agrinomicon.TaxonomyFixtures

    @invalid_attrs %{denomination: nil}

    test "list_varieties/0 returns all varieties" do
      variety = variety_fixture()
      assert Taxonomy.list_varieties() == [variety]
    end

    test "get_variety!/1 returns the variety with given id" do
      variety = variety_fixture()
      assert Taxonomy.get_variety!(variety.id) == variety
    end

    test "create_variety/1 with valid data creates a variety" do
      valid_attrs = %{denomination: "some denomination"}

      assert {:ok, %Variety{} = variety} = Taxonomy.create_variety(valid_attrs)
      assert variety.denomination == "some denomination"
    end

    test "create_variety/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Taxonomy.create_variety(@invalid_attrs)
    end

    test "update_variety/2 with valid data updates the variety" do
      variety = variety_fixture()
      update_attrs = %{denomination: "some updated denomination"}

      assert {:ok, %Variety{} = variety} = Taxonomy.update_variety(variety, update_attrs)
      assert variety.denomination == "some updated denomination"
    end

    test "update_variety/2 with invalid data returns error changeset" do
      variety = variety_fixture()
      assert {:error, %Ecto.Changeset{}} = Taxonomy.update_variety(variety, @invalid_attrs)
      assert variety == Taxonomy.get_variety!(variety.id)
    end

    test "delete_variety/1 deletes the variety" do
      variety = variety_fixture()
      assert {:ok, %Variety{}} = Taxonomy.delete_variety(variety)
      assert_raise Ecto.NoResultsError, fn -> Taxonomy.get_variety!(variety.id) end
    end

    test "change_variety/1 returns a variety changeset" do
      variety = variety_fixture()
      assert %Ecto.Changeset{} = Taxonomy.change_variety(variety)
    end
  end
end
