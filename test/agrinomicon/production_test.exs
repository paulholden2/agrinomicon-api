defmodule Agrinomicon.ProductionTest do
  use Agrinomicon.DataCase

  alias Agrinomicon.Production

  describe "tenures" do
    alias Agrinomicon.Production.Tenure

    import Agrinomicon.ProductionFixtures

    @invalid_attrs %{}

    test "list_tenures/0 returns all tenures" do
      tenure = tenure_fixture()
      assert Production.list_tenures() == [tenure]
    end

    test "get_tenure!/1 returns the tenure with given id" do
      tenure = tenure_fixture()
      assert Production.get_tenure!(tenure.id) == tenure
    end

    test "create_tenure/1 with valid data creates a tenure" do
      valid_attrs = %{occupied_at: ~U[2023-06-10 21:51:00Z], released_at: ~U[2023-06-10 21:51:00Z]}

      assert {:ok, %Tenure{} = tenure} = Production.create_tenure(valid_attrs)
      assert tenure.occupied_at == ~U[2023-06-10 21:51:00Z]
      assert tenure.released_at == ~U[2023-06-10 21:51:00Z]
    end

    @tag :skip
    test "create_tenure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Production.create_tenure(@invalid_attrs)
    end

    test "update_tenure/2 with valid data updates the tenure" do
      tenure = tenure_fixture()
      update_attrs = %{occupied_at: ~U[2023-06-11 21:51:00Z], released_at: ~U[2023-06-11 21:51:00Z]}

      assert {:ok, %Tenure{} = tenure} = Production.update_tenure(tenure, update_attrs)
      assert tenure.occupied_at == ~U[2023-06-11 21:51:00Z]
      assert tenure.released_at == ~U[2023-06-11 21:51:00Z]
    end

    @tag :skip
    test "update_tenure/2 with invalid data returns error changeset" do
      tenure = tenure_fixture()
      assert {:error, %Ecto.Changeset{}} = Production.update_tenure(tenure, @invalid_attrs)
      assert tenure == Production.get_tenure!(tenure.id)
    end

    test "delete_tenure/1 deletes the tenure" do
      tenure = tenure_fixture()
      assert {:ok, %Tenure{}} = Production.delete_tenure(tenure)
      assert_raise Ecto.NoResultsError, fn -> Production.get_tenure!(tenure.id) end
    end

    test "change_tenure/1 returns a tenure changeset" do
      tenure = tenure_fixture()
      assert %Ecto.Changeset{} = Production.change_tenure(tenure)
    end
  end

  describe "distributions" do
    alias Agrinomicon.Production.Distribution

    import Agrinomicon.ProductionFixtures

    @invalid_attrs %{coverage: 101.5}

    test "list_distributions/0 returns all distributions" do
      distribution = distribution_fixture()
      assert Production.list_distributions() == [distribution]
    end

    test "get_distribution!/1 returns the distribution with given id" do
      distribution = distribution_fixture()
      assert Production.get_distribution!(distribution.id) == distribution
    end

    test "create_distribution/1 with valid data creates a distribution" do
      valid_attrs = %{coverage: 42.5, tenure_id: tenure_fixture().id}

      assert {:ok, %Distribution{} = distribution} = Production.create_distribution(valid_attrs)
      assert distribution.coverage == 42.5
    end

    test "create_distribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Production.create_distribution(@invalid_attrs)
    end

    test "update_distribution/2 with valid data updates the distribution" do
      distribution = distribution_fixture()
      update_attrs = %{coverage: 46.7}

      assert {:ok, %Distribution{} = distribution} = Production.update_distribution(distribution, update_attrs)
      assert distribution.coverage == 46.7
    end

    test "update_distribution/2 with invalid data returns error changeset" do
      distribution = distribution_fixture()
      assert {:error, %Ecto.Changeset{}} = Production.update_distribution(distribution, @invalid_attrs)
      assert distribution == Production.get_distribution!(distribution.id)
    end

    test "delete_distribution/1 deletes the distribution" do
      distribution = distribution_fixture()
      assert {:ok, %Distribution{}} = Production.delete_distribution(distribution)
      assert_raise Ecto.NoResultsError, fn -> Production.get_distribution!(distribution.id) end
    end

    test "change_distribution/1 returns a distribution changeset" do
      distribution = distribution_fixture()
      assert %Ecto.Changeset{} = Production.change_distribution(distribution)
    end
  end
end
