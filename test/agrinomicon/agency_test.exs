defmodule Agrinomicon.AgencyTest do
  use Agrinomicon.DataCase

  alias Agrinomicon.Agency

  describe "organizations" do
    alias Agrinomicon.Agency.Organization

    import Agrinomicon.AgencyFixtures

    @invalid_attrs %{name: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Agency.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Agency.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Organization{} = organization} = Agency.create_organization(valid_attrs)
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agency.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Organization{} = organization} =
               Agency.update_organization(organization, update_attrs)

      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Agency.update_organization(organization, @invalid_attrs)

      assert organization == Agency.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Agency.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Agency.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Agency.change_organization(organization)
    end
  end

  describe "blocks" do
    alias Agrinomicon.Agency.Block

    import Agrinomicon.AgencyFixtures

    @invalid_attrs %{}

    test "list_blocks/0 returns all blocks" do
      block = block_fixture()
      assert Agency.list_blocks() == [block]
    end

    test "get_block!/1 returns the block with given id" do
      block = block_fixture()
      assert Agency.get_block!(block.id) == block
    end

    test "create_block/1 with valid data creates a block" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Block{} = block} = Agency.create_block(valid_attrs)
      assert block.name == "some name"
    end

    @tag :skip
    test "create_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Agency.create_block(@invalid_attrs)
    end

    test "update_block/2 with valid data updates the block" do
      block = block_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Block{} = block} = Agency.update_block(block, update_attrs)
      assert block.name == "some updated name"
    end

    @tag :skip
    test "update_block/2 with invalid data returns error changeset" do
      block = block_fixture()
      assert {:error, %Ecto.Changeset{}} = Agency.update_block(block, @invalid_attrs)
      assert block == Agency.get_block!(block.id)
    end

    test "delete_block/1 deletes the block" do
      block = block_fixture()
      assert {:ok, %Block{}} = Agency.delete_block(block)
      assert_raise Ecto.NoResultsError, fn -> Agency.get_block!(block.id) end
    end

    test "change_block/1 returns a block changeset" do
      block = block_fixture()
      assert %Ecto.Changeset{} = Agency.change_block(block)
    end
  end
end
